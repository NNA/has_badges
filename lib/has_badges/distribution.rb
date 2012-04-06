require_relative  '../generators/install/templates/model/badge'
require_relative  'helper'

module HasBadges
  class Distribution
    attr_reader :users, :badges

    def initialize *p
      @users = p[0].nil? ? User.includes(:badges) : p[0]
      @badges = p[1].nil? ? Badge.scoped : p[1]
    end

    def reorder_badges_for_strategy! strategy
      if strategy == :cheap 
        @badges = badges.instance_of?(ActiveRecord::Relation) ? badges.reorder(:required_points) : badges.sort! { |a,b| a.required_points <=> b.required_points }
      elsif strategy == :expensive
        @badges = badges.instance_of?(ActiveRecord::Relation) ? badges.unscoped.order(:required_points).reverse_order : badges.sort { |a,b| b.required_points <=> a.required_points }
      end
    end

    def distribute_badges strategy=:expensive
      reorder_badges_for_strategy! strategy
      users.each do |user|
        Distribution.award_badge user, first_awardable_badge(user) 
      end
    end

    def self.user_awardable_with_badge? user, badge
      return false if (user.nil? || badge.nil?)
      return false if !user.badges.empty? && user.badges.include?(badge)
      (user.points >= badge.required_points)
    end

    def first_awardable_badge user
      user_points = user.points
      Helper.fake_method_instance user, 'points', user_points do
        returned_badge = nil
        badges.each do |badge|
          if Distribution.user_awardable_with_badge?(user, badge)
            returned_badge = badge; break 
          end
        end
        returned_badge
      end
    end
    
    def self.award_badge user, badge
      return false unless user_awardable_with_badge? user, badge
      ActiveRecord::Base.transaction do
        user.badges << badge
        user.looses badge.required_points, "awarded badge #{badge.name}"
      end
      return true
      rescue
        user.reload
        UserBadge.find_by_user_id_and_badge_id(user.id, badge.id).delete
        return false
    end

  end
end