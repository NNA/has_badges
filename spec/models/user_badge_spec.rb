require 'spec_helper'

describe UserBadge  do

  subject { UserBadge.new }
  
  let :valid_attributes do
    { user_id: 10, badge_id: 10 }
  end

  let :valid_user_badge do
    UserBadge.new(valid_attributes)
  end

  it 'must persist, accept r/w of required attributes and be found by id' do
    DryFactory.only_for_this_test do
      (ub = UserBadge.create(valid_attributes)).reload
      UserBadge.find(ub.id).attributes.must_equal ub.attributes
      UserBadge.find(ub.id).attributes.keep_if{|k,v| valid_attributes.stringify_keys!.keys.include? k}.must_equal valid_attributes
    end
  end
  
  describe '#relationships' do
    it 'must belong_to a user and a badge' do
      UserBadge.reflect_on_association(:user).macro.must_equal :belongs_to
      UserBadge.reflect_on_association(:badge).macro.must_equal :belongs_to
    end
  end

  describe 'validations' do
    it 'must be a valid record when given user_id, badge_id' do
      UserBadge.new(valid_attributes).valid?.must_equal true
    end
    it 'wont be a valid record if missing user_id, badge_id' do
      UserBadge.new.valid?.wont_equal true
    end
    it 'must validate uniqueness_of' do
      DryFactory.only_for_this_test do
        ub = UserBadge.create!(valid_attributes)
        proc {UserBadge.create!(valid_attributes)}.must_raise ActiveRecord::RecordInvalid
      end
    end
  end
  
  describe '#mass_assignable_attr' do
    it 'must be possible to assign user_id and badge_id' do
      UserBadge.accessible_attributes.to_a.must_equal ['user_id', 'badge_id']
    end
  end
  
end