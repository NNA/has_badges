require 'minitest/spec'
require 'spec_helper'

describe HasBadges::Distribution do
  let (:user_created_10_points)   { user_builded_10_points.save ; user_builded_10_points}
  let (:user_builded_10_points)   { user = DryFactory.build(:user) ; user.point_logs.build(:amount => 10, :date => 1.minute.ago) ; user}

  let (:user_stubbed_0_points)    { DryFactory.build_stubbed(:user, :points => 0) }
  let (:user_stubbed_10_points)   { DryFactory.build_stubbed(:user, :points => 10)}

  let(:badge_requiring_60_points) { DryFactory.build :badge, :required_points => 60 }
  let(:badge_requiring_10_points) { DryFactory.build :badge, :required_points => 10 }

  let :newbie_badge do
    DryFactory.build(:badge)
  end

  let :user_with_newbie_badge do
    DryFactory.build_stubbed :user, :badges => [newbie_badge]
  end

  # describe :distribute_badges do
  #   it 'award badges to given users' do
  #     HasBadges::Distribution.distribute_badges(User.all)
  #   end
  # end

  # describe :award_first_possible_badge do
  # 	it 'give user the first badges in can have within the given badges' do

  # 	end
  # end

  describe :award_badge do
    it 'awardable?: return true, award badge and reduce points with amount of points required by badge' do
      user_created_10_points
      DryFactory.rollback_after_block do
        HasBadges::Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns true  
        
        HasBadges::Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal true
        
        user_created_10_points.badges.must_equal [badge_requiring_10_points]
        user_created_10_points.points.must_equal 0
      end
    end

    it 'not awardable?: return false not award badge and not withdraw points' do
      user_created_10_points
      DryFactory.rollback_after_block do
        HasBadges::Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns false
        
        HasBadges::Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal false
        
        user_created_10_points.badges.must_equal []
        user_created_10_points.points.must_equal 10
      end
    end

    it 'awardable? but Exception raised: return false not award badge and not reduce points' do
      user_created_10_points
      DryFactory.rollback_after_block do
        HasBadges::Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns true
        Point.stubs(:create).raises 'someException'

        HasBadges::Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal false

        user_created_10_points.badges.must_equal []
        user_created_10_points.points.must_equal 10
      end
    end
  end

  describe :user_awardable_with_badge? do
    it 'must return false if a parameter is nil' do
      # TODO: Improvement: raise exception instead
      HasBadges::Distribution.user_awardable_with_badge?(nil, nil).must_equal false
    end

    it 'must return true if user has more or equal than the number of points required by the badge and han\'t already this badge' do
      HasBadges::Distribution.user_awardable_with_badge?(user_stubbed_10_points, badge_requiring_10_points).must_equal true
    end

    it 'must return false if user has fewer points than required by the badge' do
      HasBadges::Distribution.user_awardable_with_badge?(user_stubbed_10_points, badge_requiring_60_points).must_equal false
      HasBadges::Distribution.user_awardable_with_badge?(user_stubbed_0_points, badge_requiring_10_points).must_equal false
    end

    it 'should return false if user already has the given badge' do
      HasBadges::Distribution.user_awardable_with_badge?(user_with_newbie_badge, newbie_badge).must_equal false
    end
  end
end