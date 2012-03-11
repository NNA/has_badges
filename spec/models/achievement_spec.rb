require 'spec_helper'

describe Achievement  do

  subject { Achievement.new }
  
  let :valid_attributes do
    {name: 'achievement', points_rewarded: 3}
  end

  let :valid_achivement do
    Achievement.new(valid_attributes)
  end
  
  it 'must persist, accept r/w of required attributes and be found by id' do
    DryFactory.only_for_this_test do
      (ach = Achievement.create(valid_attributes)).reload
      Achievement.find(ach.id).attributes.must_equal ach.attributes
      Achievement.find(ach.id).attributes.keep_if{|k,v| valid_attributes.stringify_keys!.keys.include? k}.must_equal valid_attributes
    end
  end
  
  describe 'validations' do
    describe 'presence_of' do
      it 'must be a valid record when given name and points_rewarded' do
        valid_achivement.valid?.must_equal true
      end

      it 'wont be a valid record if missing name' do
        subject.valid?.wont_equal true
      end
    end

    describe 'numericallity_of' do
      it 'wont have errors when assignning number to points_rewarded' do
        subject.tap{|o|o.send("points_rewarded=", 3)}.tap(&:valid?).errors[:points_rewarded].must_equal []
      end

      it 'must have errors if assigning number to points_rewarded' do
        subject.tap{|o|o.send("points_rewarded=", 'abc')}.tap(&:valid?).errors[:points_rewarded].must_equal ['is not a number']
      end
    end

  end

  describe 'assignable_attributes' do
    it 'must be possible to assign name and rewarded points' do
      subject.class.accessible_attributes.to_a.must_equal ['name', 'points_rewarded']
    end
  end
end