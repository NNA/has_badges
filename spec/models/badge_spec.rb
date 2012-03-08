require 'minitest/spec'
require 'spec_helper'

require  File.join(Dir.pwd,"lib/generators/install/templates/model/badge")

describe 'Badge'  do
	
  describe '#validations' do
    it 'must be a valid record when given a name' do
      req_attr = { name: 'my_name'}
      Badge.new(req_attr).valid?.must_equal true
    end
    it 'wont be a valid record if missing amount and date' do
      Badge.new.valid?.wont_equal true
    end
  end

  describe '#mass_assignable_attr' do
    it 'must be possible to assign name' do
      Badge.accessible_attributes.to_a.must_equal ['name']
    end
  end
end