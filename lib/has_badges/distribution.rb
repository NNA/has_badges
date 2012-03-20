module HasBadges
  class Distribution

    def self.user_awardable_with_badge? user, badge
      return false if (user.nil? || badge.nil?)
      return false if !user.badges.empty? && user.badges.include?(badge)
      (user.points >= badge.required_points)
    end

    def self.award_badge user, badge
      if user_awardable_with_badge? user, badge
        ActiveRecord::Base.transaction do
          user.badges << badge
          user.looses badge.required_points, "awarded badge #{badge.name}"
        end
        true
      else
        false
      end
    end

  end
end