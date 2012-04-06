require 'minitest/spec'
require 'spec_helper'

include HasBadges

describe Distribution do
  subject                         { Distribution.new }

  let (:user)                     {DryFactory.build :user}
  let (:badge)                    {DryFactory.build :badge}
  
  let (:user_created_10_points) {
    user_builded_10_points.tap(&:save)
    # {:user_created_10_points => user_builded_10_points} 
  }

  let (:user_builded_10_points)   { user = DryFactory.build(:user) ; user.point_logs.build(:amount => 10, :date => 1.minute.ago) ; user}

  let (:user_stubbed_0_points)    { DryFactory.build_stubbed(:user, :points => 0) }
  let (:user_stubbed_10_points)   { DryFactory.build_stubbed(:user, :points => 10)}

  let(:badge_requiring_60_points) { DryFactory.build :badge, :required_points => 60 }
  let(:badge_requiring_10_points) { DryFactory.build :badge, :required_points => 10 }

  # before do
  #   DryFactory.access_as_class_vars_from self, [:user_created_10_points]
  # end
  
  describe :initialize do
    it 'must create a new instance of Distribution and set users and badges info as accessible instance methods' do
      distrib = Distribution.new(['users', 'tab'], ['badges', 'tab'])
      distrib.users.must_equal  ['users', 'tab']
      distrib.badges.must_equal ['badges', 'tab']
    end

    it 'given no args must set users and badges to all' do
      User.stubs(:includes).with(:badges).returns('all_users')
      Badge.stubs(:scoped).returns('all_badges')

      distrib = Distribution.new
      distrib.users.must_equal 'all_users'
      distrib.badges.must_equal 'all_badges'
    end
  end

  describe :distribute_badges do
    describe 'given no strategy' do
      it 'must reorder badges using :expensive strategy and award first_awardable_badge to every user Users' do
        distrib = Distribution.new([user_mock_1= mock('user'), user_mock_2= mock('user')], 
                                   [badge_requiring_10_points, badge_requiring_60_points])
      
        distrib.expects(:reorder_badges_for_strategy!).with(:expensive).returns([badge_requiring_60_points, badge_requiring_10_points])

        distrib.expects(:first_awardable_badge).with(user_mock_1).returns(badge_requiring_60_points)
        distrib.expects(:first_awardable_badge).with(user_mock_2).returns(badge_requiring_10_points)

        Distribution.expects(:award_badge).with(user_mock_1, badge_requiring_60_points).once
        Distribution.expects(:award_badge).with(user_mock_2, badge_requiring_10_points).once
        
        distrib.distribute_badges
      end
    end
  end

  describe :first_awardable_badge do
    before do
      Distribution.stubs(:user_awardable_with_badge?).with(user, @not_awardable_badge    = DryFactory.build(:badge)).returns false
    end

    it 'returns the first badges the given user can be awarded within the @badges' do
      Distribution.stubs(:user_awardable_with_badge?).with(user, first_awardable_badge  = DryFactory.build(:badge)).returns true
      Distribution.stubs(:user_awardable_with_badge?).with(user, second_awardable_badge = DryFactory.build(:badge)).returns true
      subject.stubs(:badges).returns [first_awardable_badge, second_awardable_badge, @not_awardable_badge]

      subject.first_awardable_badge(user).must_equal first_awardable_badge
    end

    it 'returns nil if the user cannot be awarded with any of @badges' do
      subject.stubs(:badges).returns [@not_awardable_badge]
      
      subject.first_awardable_badge(user).must_equal nil
    end
  end

  describe :award_badge do
    it 'awardable?: return true, award badge and reduce points with amount of points required by badge' do
      user_created_10_points
      DryFactory.rollback_after_block do
        Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns true  
        
        Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal true
        
        user_created_10_points.badges.must_equal [badge_requiring_10_points]
        user_created_10_points.points.must_equal 0
      end
    end

    it 'not awardable?: return false not award badge and not withdraw points' do
      user_created_10_points
      DryFactory.rollback_after_block do
        Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns false
        
        Distribution.award_badge(user_created_10_points, badge_requiring_10_points).must_equal false
        
        user_created_10_points.badges.must_equal []
        user_created_10_points.points.must_equal 10
      end
    end

    it 'awardable? but Exception raised: return false not award badge and not reduce points' do
      user_created_10_points
      DryFactory.rollback_after_block do
        Distribution.stubs(:user_awardable_with_badge?).with(user_created_10_points, badge_requiring_10_points).returns true
        user_created_10_points.stubs(:looses).raises 'someException'
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

    it 'must return false if user already has the given badge' do
      user.stubs(:badges).returns([badge])
      Distribution.user_awardable_with_badge?(user, badge).must_equal false
    end
  end

  describe :reorder_badges_for_strategy! do
    describe 'given AR Relation' do
      it 'given :cheap strategy, must order @badges in points_required order' do
        DryFactory.rollback_after_block do
          badge_requiring_60_points.save
          badge_requiring_10_points.save
          distri = Distribution.new(User.all, Badge.order('required_points DESC'))

          distri.reorder_badges_for_strategy!(:cheap)

          distri.badges.must_be_instance_of ActiveRecord::Relation
          distri.badges.must_equal [badge_requiring_10_points, badge_requiring_60_points]
        end
      end

      it 'given :expensive strategy, must order @badges in reverse points_required order' do
        DryFactory.rollback_after_block do
          badge_requiring_60_points.save
          badge_requiring_10_points.save
          distri = Distribution.new(User.all, Badge.order(:required_points))

          distri.reorder_badges_for_strategy!(:expensive)
          
          distri.badges.must_be_instance_of ActiveRecord::Relation
          distri.badges.must_equal [badge_requiring_60_points, badge_requiring_10_points]
        end
      end      
    end

    describe 'given Array' do
      it 'given :cheap strategy, must sort @badges in reverse points_required order' do
        distri = Distribution.new(User.all, [badge_requiring_60_points, badge_requiring_10_points])
        distri.reorder_badges_for_strategy!(:cheap)
        distri.badges.must_equal [badge_requiring_10_points, badge_requiring_60_points]
      end

      it 'given :expensive strategy, must sort @badges in reverse points_required order' do
        distri = Distribution.new(User.all, [badge_requiring_10_points, badge_requiring_60_points])
        distri.reorder_badges_for_strategy!(:expensive)
        distri.badges.must_equal [badge_requiring_60_points, badge_requiring_10_points]
      end
    end
  end
  
end