module HasBadges
  module HasBadgesExtensions
    def self.included(base)
      base.extend ActMethods
    end 

    module ActMethods
      def has_badges(options = {})
        options[:class_name] ||= 'Badge'
        
        unless included_modules.include? InstanceMethods
          class_attribute :options
          table_name = options[:class_name].constantize.table_name
          
          has_many :point_logs,
                   :class_name => 'Point'

          has_many :user_badges,
                   :foreign_key => 'user_id'

          has_many :badges,
                   :through => :user_badges,
                   :class_name => options[:class_name],
                   :foreign_key => 'user_id'

          extend ClassMethods 
          include InstanceMethods 
        end
        self.options = options
      end
    end

    module ClassMethods
      # None yet...
    end

    module InstanceMethods
      def has_badge? badge_name
        # UserBadge.where(:user_id => self.id, :badge_id => Badge.find_by_name(badge_name).try(:id)).count == 1
        !self.badges.where(:name => badge_name).empty?
      end

      def points
        self.point_logs.sum(:amount)
      end
    end 
  end
end

if defined? ActiveRecord
  ActiveRecord::Base.class_eval do
    include HasBadges::HasBadgesExtensions
  end
end