class Point < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id,
  				  :amount,
  				  :reason,
  				  :date

  validates_presence_of :amount,
  						:date
end