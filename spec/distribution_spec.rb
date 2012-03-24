require 'minitest/spec'
require 'spec_helper'

include HasBadges

describe Distribution do
  let (:user)                     {DryFactory.build :user}
  let (:badge)                    {DryFactory.build :badge}
  let (:user_created_10_points)   { user_builded_10_points.tap(&:save) ; {:user_created_10_points => user_builded_10_points} }

  let (:user_builded_10_points)   { user = DryFactory.build(:user) ; user.point_logs.build(:amount => 10, :date => 1.minute.ago) ; user}

  let (:user_stubbed_0_points)    { DryFactory.build_stubbed(:user, :points => 0) }
  let (:user_stubbed_10_points)   { DryFactory.build_stubbed(:user, :points => 10)}

  let(:badge_requiring_60_points) { DryFactory.build :badge, :required_points => 60 }
  let(:badge_requiring_10_points) { DryFactory.build :badge, :required_points => 10 }

  before do
    DryFactory.access_as_class_vars_from self, [:user_created_10_points]
  end

  describe :distribute_badges do
    it 'award the first_possible_badge in the given list of badges to all given users' do
      Distribution.expects(:first_awardable_badge).with(user_mock_1= mock('user'), anything).once.returns(badge_mock_1 = mock('badge'))
      Distribution.expects(:first_awardable_badge).with(user_mock_2= mock('user'), anything).once.returns(badge_mock_2 = mock('badge'))

      Distribution.expects(:award_badge).with(user_mock_1, badge_mock_1).once.returns true
      Distribution.expects(:award_badge).with(user_mock_2, badge_mock_2).once.returns true 
      
      Distribution.distribute_badges([user_mock_1, user_mock_2], [badge_mock_1, badge_mock_2])
    end
  end

  describe :first_awardable_badge do
    before do
      Distribution.stubs(:user_awardable_with_badge?).with(user, @not_awardable_badge    = DryFactory.build(:badge)).returns false
    end

    it 'returns the first badges the given user can be awarded within the given badges' do
      Distribution.stubs(:user_awardable_with_badge?).with(user, first_awardable_badge  = DryFactory.build(:badge)).returns true
      Distribution.stubs(:user_awardable_with_badge?).with(user, second_awardable_badge = DryFactory.build(:badge)).returns true
      badges = [first_awardable_badge, second_awardable_badge, @not_awardable_badge]

      Distribution.first_awardable_badge(user, badges).must_equal first_awardable_badge
    end

    it 'returns nil if the user cannot be awarded with any of the given badges' do
      badges = [@not_awardable_badge]
      
      Distribution.first_awardable_badge(user, badges).must_equal nil
    end
  end

  describe :award_badge do
    it 'awardable?: return true, award badge and reduce points with amount of points required by badge' do
      @user_created_10_points
      DryFactory.rollback_after_block do
        Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns true  
        
        Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal true
        
        user_created_10_points.badges.must_equal [badge_requiring_10_points]
        user_created_10_points.points.must_equal 0
      end
    end

    it 'not awardable?: return false not award badge and not withdraw points' do
      @user_created_10_points
      DryFactory.rollback_after_block do
        Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns false
        
        Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal false
        
        user_created_10_points.badges.must_equal []
        user_created_10_points.points.must_equal 10
      end
    end

    it 'awardable? but Exception raised: return false not award badge and not reduce points' do
      @user_created_10_points
      DryFactory.rollback_after_block do
        Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns true
        Point.stubs(:create).raises 'someException'

        Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal false

        user_created_10_points.badges.must_equal []
        user_created_10_points.points.must_equal 10
      end
    end
  end

  describe :user_awardable_with_badge? do
    it 'must return false if a parameter is nil' do
      # TODO: Improvement: raise exception instead
      Distribution.user_awardable_with_badge?(nil, nil).must_equal false
    end

    it 'must return true if user has more or equal than the number of points required by the badge and han\'t already this badge' do
      Distribution.user_awardable_with_badge?(user_stubbed_10_points, badge_requiring_10_points).must_equal true
    end

    it 'must return false if user has fewer points than required by the badge' do
      Distribution.user_awardable_with_badge?(user_stubbed_10_points, badge_requiring_60_points).must_equal false
      Distribution.user_awardable_with_badge?(user_stubbed_0_points, badge_requiring_10_points).must_equal false
    end

    it 'should return false if user already has the given badge' do
      user.stubs(:badges).returns([badge])
      Distribution.user_awardable_with_badge?(user, badge).must_equal false
    end
  end
end