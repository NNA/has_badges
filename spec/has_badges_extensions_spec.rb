require 'minitest/spec'
require 'minitest/autorun'
require  File.join(Dir.pwd,"lib/has_badges")
require 'spec_helper'

describe 'User with badges_extensions' do

	let :user_without_badges do
	  @user = Helper.create_user(:login => 'user_with_no_badge')
	  @user
	end

	let :user_with_newbie_badge do
	  @user = Helper.create_user(:login => 'user_with_newbie_badge')
	  @newbie_badge = Helper.create_badge(:name => 'Newbie')
	  Helper.create_user_badge(:user_id => @user.id, :badge_id => @newbie_badge.id)
	  @user
	end

	before do
     # puts "self.public_methods #{self.methods false}"
		 %w(user_without_badges user_with_newbie_badge).each do |context|
       if (cache = Helper.class_variable_get("@@data_cache"))[context.to_sym].nil?
			 	 Helper.class_variable_set("@@data_cache", cache.merge({context.to_sym => eval(context)}))
			 end
			 instance_variable_set("@#{context}", Helper.class_eval("@@data_cache")[context.to_sym])
		 end

		 # if Helper.class_variable_get(:@@user_without_badges).nil?
		 # 	 Helper.class_variable_set(:@@user_without_badges, user_without_badges)
		 # end
		 # @user_without_badges = Helper.class_eval("@@user_without_badges")

		 # if Helper.class_variable_get(:@@user_with_newbie_badge).nil?
		 # 	 Helper.class_variable_set(:@@user_with_newbie_badge, user_with_newbie_badge)
		 # end
		 # @user_with_newbie_badge = Helper.class_eval("@@user_with_newbie_badge")

		 # Helper.clean_data
		 # @user_without_badges =  Helper.create_user # refactor with ||=
		 
	  #  @user_with_newbie_badge = Helper.create_user
	  #  @newbie_badge 					 = Helper.create_badge(:name => 'Newbie')
  	#  Helper.create_user_badge(:user_id => @user_with_newbie_badge.id, :badge_id => @newbie_badge.id)
	end

  describe :badges do
    it 'must return an array of badges acquired by this user' do
    	@user_with_newbie_badge.badges.must_equal [@newbie_badge]
    end

    it 'must return an empty array if user has no badges' do
      @user_without_badges.badges.must_equal []
    end
  end

  describe :has_badge? do
    it 'must return true if user has 1 badge' do
    	@user_with_newbie_badge.has_badge?('Newbie').must_equal true
    end
    it 'must return false if user has another badge' do
      @user_with_newbie_badge.has_badge?('FakeBadge').must_equal false
    end
    it 'must return false if user has no badges' do
    	@user_without_badges.has_badge?('Newbie').must_equal false
    end
  end
  
  describe :points_log do
    it "must return an empty array if user has no point logs" do
      skip 'wip'
      @user_without_points.points_log.must_equal []
    end
    it "must return an array of points log if user has earned points" do
      skip 'to_be_done'
    end
  end

  describe :points do
  	it 'must do something' do
  		skip 'to_be_done'
	  end
  end

  describe :earns do
  	it 'must add given number of points to the user' do
      skip 'to_be_done'
      # @nicolas.earns(30)
      # @nicolas.points.must_equal 30
    end
  end

end