class Point < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id,
  				  :amount,
  				  :date,
  				  :reason

  validates_presence_of :amount,
  						:date
end