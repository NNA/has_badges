class Badge < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :name

  validates_presence_of :name
end