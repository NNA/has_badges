require 'spec_helper'

describe Point  do
  
  subject { Point.new }
  
  let :valid_attributes do
    {user_id: 1, amount: 10, date: 1.day.ago}
  end

  let :assignable_attributes do
    {user_id: 1, amount: 10, date: 1.day.ago, reason:'some_resaon', used: false}
  end

  let :valid_point do
    Point.new(valid_attributes)
  end

  it 'must persist, accept r/w of assignable attributes and be found by id' do
    DryFactory.only_for_this_test do
      (point = Point.create(assignable_attributes)).reload
      Point.find(point.id).attributes.must_equal point.attributes
      Point.find(point.id).attributes.keep_if{|k,v| assignable_attributes.stringify_keys!.keys.include? k}.must_equal assignable_attributes
      point
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
    it 'must be possible to assign assignable attributes' do
      Point.accessible_attributes.to_a.must_equal assignable_attributes.stringify_keys!.keys
    end
  end
  
end