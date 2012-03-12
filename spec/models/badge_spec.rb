require 'spec_helper'

describe Badge  do
  
  subject { Badge.new }
  
  let :valid_attributes do
    {name: 'my_name'}
  end

  let :valid_badge do
    Badge.new(valid_attributes)
  end

  it 'must persist, accept r/w of required attributes and be found by id' do
    DryFactory.only_for_this_test do
      (badge = Badge.create(valid_attributes)).reload
      Badge.find(badge.id).attributes.must_equal badge.attributes
      Badge.find(badge.id).attributes.keep_if{|k,v| valid_attributes.stringify_keys!.keys.include? k}.must_equal valid_attributes
      badge
    end
  end
	
  describe 'validations' do
    describe 'presence_of' do
      it 'must be a valid record when given name' do
        valid_badge.valid?.must_equal true
      end

      it 'wont be a valid record if missing name' do
        subject.valid?.wont_equal true
      end
    end
  end

  describe 'assignable_attributes' do
    it 'must be possible to assign name' do
      Badge.accessible_attributes.to_a.must_equal ['name']
    end
  end
end