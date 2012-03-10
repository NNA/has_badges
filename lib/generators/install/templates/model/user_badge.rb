class UserBadge < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
  
  attr_accessible 	:user_id, 
  					:badge_id

  validates_presence_of :user_id, 
  						:badge_id
  
  validates_uniqueness_of :user_id, :scope => [:badge_id]
end