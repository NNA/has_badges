module HasBadges
  class Distribution

    def self.distribute_badges users, badges
      users.each do |user|
        award_badge user, first_awardable_badge(user, badges) 
      end
    end

    def self.user_awardable_with_badge? user, badge
      return false if (user.nil? || badge.nil?)
      return false if !user.badges.empty? && user.badges.include?(badge)
      (user.points >= badge.required_points)
    end

    def self.first_awardable_badge user, badges
      user_points = user.points
      Helper.fake_method_instance user, 'points', user_points do
        returned_badge = nil
        badges.each do |badge|
          if user_awardable_with_badge?(user, badge)
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
      true
    rescue
      user.reload
      false
    end

  end
end