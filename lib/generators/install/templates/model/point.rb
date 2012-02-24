class Point < ActiveRecord::Base
  belongs_to :user

  # new columns need to be added here to be writable through mass assignment
  attr_accessible :amount
  attr_accessible :user_id

  validates_presence_of :amount
end