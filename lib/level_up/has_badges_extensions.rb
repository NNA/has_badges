module LevelUp
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
          
          has_many :user_badges,
                   # :class_name  => "UserBadges",
                   :foreign_key => 'user_id'

          has_many :badges,
                   :through => :user_badges,
                   :class_name => options[:class_name],
                   :foreign_key => 'user_id'
                   # ,
                   # :order => "#{table_name}.created_at DESC",
                   # :conditions => ["#{table_name}.sender_deleted = ?", false]

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
        UserBadge.where(:user_id => self.id, :badge_id => Badge.find_by_name(badge_name).try(:id)).count == 1
      end
      
      # # Returns the number of unread messages for this user
      # def unread_message_count
      #   eval options[:class_name] + '.count(:conditions => ["recipient_id = ? AND read_at IS NULL and recipient_deleted = ?", self, false])'
      # end
    end 
  end
end

if defined? ActiveRecord
  ActiveRecord::Base.class_eval do
    include LevelUp::HasBadgesExtensions
  end
end