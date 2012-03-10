class Achievement < ActiveRecord::Base
  validates_presence_of :name, 
  						:points_rewarded

  validates_numericality_of   :points_rewarded

  attr_accessible :name,
                  :points_rewarded
end
