require 'minitest/spec'
require 'spec_helper'

describe HasBadges::Distribution do
  let :user_stubbed_ten_points do
    user = DryFactory.build :user
    # ten_points = DryFactory.create :point, :user_id => user_with_ten_points.id, :amount => 10
    user.stubs(:points).returns(10)
    user
  end

  let :badge_requiring_ten_points do
    DryFactory.build :badge, :required_points => 10
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

  # describe :award_badge do
  #   it 'Enough points: return true, award badge and withdraw points' do
  #     Distribution.stubs(:user_awardable_with_badge?).with(user, badge).returns true  
  #     Distribution.award_badge(badge_requiring_10_points, user).must_equal true
  #     user.badges.must_equal badge_requiring_10_points
  #     user.points.must_equal 0
  #   end

  #   it 'Not enough points: return false not award badge and not withdraw points' do

  #   end

  #   it 'Enough points but something happens: return false not award badge and not withdraw points' do

  #   end
  # end

  describe :user_awardable_with_badge? do
    it 'must return false if a parameter is nil' do
      # improvement: raise exception instead
      HasBadges::Distribution.user_awardable_with_badge?(nil, nil).must_equal false
    end

    it 'must return true if user has more or equal than the number of points required by the badge and han\'t already this badge' do
      HasBadges::Distribution.user_awardable_with_badge?(user_stubbed_ten_points, badge_requiring_ten_points).must_equal true
    end

    # it 'must return false if user has fewer points than required by the badge' do
    #   HasBadges::Distribution.user_awardable_with_badge?(user_with_ten_points, badge_requiring_sixty_points).must_equal false
    #   HasBadges::Distribution.user_awardable_with_badge?(user_without_points, badge_requiring_sixty_points).must_equal false
    # end

    # it 'should return false if user already have the given badge' do
    #   HasBadges::Distribution.user_awardable_with_badge?(user_with_newbie_badge, newbie_badge).must_equal false
    # end
  end
end