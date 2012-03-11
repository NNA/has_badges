require 'minitest/spec'
require 'minitest/autorun'
require 'mocha'
require  File.join(Dir.pwd,"lib/has_badges")
require 'spec_helper'

describe 'User with badges_extensions' do

	let :user do
	  user = DryFactory.create_user(:login => 'user_with_no_badge')
	  { :user => user }
	end

	let :user_with_newbie_badge do
	  user_with_newbie_badge = DryFactory.create_user(:login => 'user_with_newbie_badge')
	  newbie_badge = DryFactory.create_badge(:name => 'Newbie')
	  DryFactory.create_user_badge(:user_id => user_with_newbie_badge.id, :badge_id => newbie_badge.id)
	  { :user_with_newbie_badge => user_with_newbie_badge, :newbie_badge => newbie_badge }
	end

  let :user_with_ten_points do
    user_with_ten_points = DryFactory.create_user(:login => 'user_with_points')
    ten_points = DryFactory.create_user_point(:user_id => user_with_ten_points.id, :amount => 10)
    { :user_with_ten_points => user_with_ten_points, :ten_points => ten_points }
  end

  before do
    DryFactory.access_as_class_vars_from self, [:user, :user_with_newbie_badge, :user_with_ten_points]
  end

  describe :badges do
    it 'must return an array of badges acquired by this user' do
      @user_with_newbie_badge.badges.must_equal [@newbie_badge]
    end

    it 'must return an empty array if user has no badges' do
      @user.badges.must_equal []
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
      @user.has_badge?('Newbie').must_equal false
    end
  end
  
  describe :points_log do
    it "must return an empty array if user has no point logs" do
      @user.point_logs.must_equal []
    end
    it "must return an array of points log if user has earned points" do
      @user_with_ten_points.point_logs.must_equal [@ten_points]
    end
  end

  describe :points do
    it 'must return 0 if user has no points' do
      @user.points.must_equal 0
    end
    it 'must return 15 if user has 10 + 5 points in his history' do
      DryFactory.only_for_this_test do
        five_extra_points = DryFactory.create_user_point(:user_id => @user_with_ten_points.id, :amount => 5)
        @user_with_ten_points.points.must_equal 15
      end
    end
  end

  describe :wins do
    it 'must add given number of points to the user and save reason why' do
      Time.stubs(:now).returns('now')
      Point.expects(:create).with(:user_id  => @user.id, 
                                  :amount   => 30, 
                                  :reason   => 'Giving back to open source',
                                  :date     => Time.now).returns(plus_30_points = mock())
      @user.wins(30, 'Giving back to open source').must_equal plus_30_points
    end

    it 'raise exception if no amount given' do
      proc {@user.wins}.must_raise ArgumentError
    end
  end

  describe :looses do
    it 'should bahave like win except that points are negatively saved' do
      Time.stubs(:now).returns('now')
      Point.expects(:create).with(:user_id  => @user.id, 
                                  :amount   => -10, 
                                  :reason   => 'Spamming users',
                                  :date     => 'now').returns(minus_10_points = mock())
      @user.looses(10, 'Spamming users').must_equal minus_10_points
    end
  end

end