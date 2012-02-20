gem "minitest"
require 'minitest/spec'
require 'minitest/autorun'
require  File.join(Dir.pwd,"lib/level_up")

describe LevelUp::LevelUp do
  describe :earn do
    it "must insert given number of points in database" do
      LevelUp::LevelUp.earn(30).must_equal true
    end
  end
end