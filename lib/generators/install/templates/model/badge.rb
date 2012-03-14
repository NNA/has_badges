class Badge < ActiveRecord::Base
  attr_accessible :name, 
  				  :required_points

  validates_presence_of :name,
  						:required_points
end