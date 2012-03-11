require 'spec_helper'

describe Point  do
  
  subject { Point.new }
  
  let :valid_attributes do
    {user_id: 1, amount: 10, date: 1.day.ago}
  end

  let :valid_point do
    Point.new(valid_attributes)
  end

  it 'must persist, accept r/w of required attributes and be found by id' do
    DryFactory.only_for_this_test do
      (point = Point.create(valid_attributes)).reload
      Point.find(point.id).attributes.must_equal point.attributes
      Point.find(point.id).attributes.keep_if{|k,v| valid_attributes.stringify_keys!.keys.include? k}.must_equal valid_attributes
    end
  end

  describe 'relationships' do
    it 'must belong_to a user' do
      Point.reflect_on_association(:user).macro.must_equal :belongs_to
    end
  end
  
  describe 'validations' do
    it 'must be a valid record when given user_id, amount, date' do
      valid_point.valid?.must_equal true
    end
    it 'wont be a valid record if missing user_id, amount, date' do
      Point.new.valid?.wont_equal true
    end
  end
  
  describe 'assignable_attributes' do
    it 'must be possible to assign amount, date, user_id and reason' do
      Point.accessible_attributes.to_a.must_equal ['user_id', 'amount', 'date', 'reason']
    end
  end
  
end