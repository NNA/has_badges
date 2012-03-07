require 'minitest/spec'
require 'spec_helper'

require  File.join(Dir.pwd,"lib/generators/install/templates/model/badge")

describe 'BadgeModel'  do
	describe '#validations' do
    it 'must persits when given a name' do
      Badge.create!(:name => 'Dev Geek').reload.name.must_equal 'Dev Geek'
    end
    it 'must raise Exception without given a name' do
      proc {Badge.create!()}.must_raise ActiveRecord::RecordInvalid
    end
  end
end