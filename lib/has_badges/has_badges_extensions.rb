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
        !self.badges.where(:name => badge_name).empty?
      end

      def points
        self.persisted? ? self.point_logs.sum(:amount) : self.point_logs.to_a.sum(&:amount) 
      end

      def wins amount, reason=nil
        Point.create(:user_id => self.id, :amount => amount, :reason => reason, :date => Time.now )
      end

      def looses amount, reason=nil
        self.wins (-amount).to_i, reason
      end
    end 
  end
end

if defined? ActiveRecord
  ActiveRecord::Base.class_eval do
    include HasBadges::HasBadgesExtensions
  end
end