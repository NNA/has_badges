require 'minitest/spec'
require 'minitest/autorun'
require  File.join(Dir.pwd,"lib/level_up")
require 'spec_helper'

describe 'User with badges_extensions' do

	before do
		Helper.clean_data
		@nicolas = Helper.create_user
	  @newbie  = Helper.create_badge
	  Helper.create_user_badge(:user_id => @nicolas.id, :badge_id => @newbie.id)
	end

  describe :badges do
    it 'must return an array of badges acquired by this user' do
      @nicolas.badges.must_equal [@newbie]
    end
  end

  describe :has_badge? do
    it 'must return true if given user has given badge' do
    	@nicolas.has_badge?('Newbie').must_equal true
    end

    it 'must return false if given user has not given badge' do
    	@another_badge  = Helper.create_badge({:name => 'another_badge'})
      @nicolas.has_badge?('another_badge').must_equal false
    end

    it 'must return false if given user has not given badge' do
      @nicolas.has_badge?('another_badge').must_equal false
    end
  end
  
  describe :earn do   
    it "must return true" do
      skip "in progress"
      @nicolas.earn(30).must_equal true
    end
  end

end