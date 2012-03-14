module HasBadges
  class Distribution

    def self.user_awardable_with_badge? user, badge
      return false if( user.nil? || badge.nil?)
      return false if !user.badges.empty? && user.badges.include?(badge)
      (user.points >= badge.required_points)
    end

  end
end