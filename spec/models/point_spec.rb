require 'minitest/spec'
require 'spec_helper'

require  File.join(Dir.pwd,"lib/generators/install/templates/model/point")

describe 'PointModel'  do
	describe '#validations' do
    it 'must persits when given an amount and date' do
      point_attr = { amount: 1, date: 1.day.ago }
      Point.create!(point_attr).reload.attributes.select{|k,v| k == 'amount' || k == 'date' }.symbolize_keys!.must_equal point_attr
    end
    it 'must raise Exception if not given an amount and date' do
      proc {Point.create!()}.must_raise ActiveRecord::RecordInvalid
    end
  end
end