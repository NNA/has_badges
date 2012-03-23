module HasBadges
  class Distribution

    def self.user_awardable_with_badge? user, badge
      return false if (user.nil? || badge.nil?)
      return false if !user.badges.empty? && user.badges.include?(badge)
      (user.points >= badge.required_points)
    end

    # def self.first_awardable_badge user, badges
    #   user_points = user.points
    #   puts "#{Helper.toto}"
    #   # User.send(:define_method, 'points', proc {user_points})
    #   user.instance_exec(user_points) { |param|
    #     @new_points = param
    #     def new_points
    #       @new_points
    #     end
    #     alias :old_points :points
    #     alias :points :new_points }
    #   puts "before in #{user.points}"
    #   user.instance_eval { alias :points :old_points }
    #   puts "after in #{user.points}"
    #   badges.each do |badge|
    #     return badge if user_awardable_with_badge?(user, badge)
    #   end
    # end

    def self.first_awardable_badge user, badges
      user_points = user.points
      Helper.fake_method_instance user, 'points', 10 do
        returned_badge = nil
        badges.each do |badge|
          #return badge if user_awardable_with_badge?(user, badge)
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