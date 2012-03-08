require 'minitest/spec'
require 'spec_helper'

require  File.join(Dir.pwd,"lib/generators/install/templates/model/point")

describe 'Point'  do
  
  describe '#relationships' do
    it 'must belong_to a user' do
      Point.reflect_on_association(:user).macro.must_equal :belongs_to
    end
  end
  
  describe '#validations' do
    it 'must be a valid record when given amount and date' do
      Point.new({ amount: 1, date: 1.day.ago }).valid?.must_equal true
    end
    it 'wont be a valid record if missing amount and date' do
      Point.new.valid?.wont_equal true
    end
  end
  
  describe '#mass_assignable_attr' do
    it 'must be possible to assign amount, date, user_id and reason' do
      Point.accessible_attributes.to_a.must_equal ['user_id', 'amount', 'date', 'reason']
    end
  end
  
end