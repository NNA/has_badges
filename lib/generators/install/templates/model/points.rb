class Points < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :amount

  validates_presence_of :amount
end