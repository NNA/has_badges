class Achievement < ActiveRecord::Base
  attr_accessible :name,
                  :points_rewarded
end
