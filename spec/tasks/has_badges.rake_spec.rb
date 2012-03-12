require 'spec_helper'
require 'rake'
require 'mocha'

describe "has_badge rake tasks" do
	it 'distribute badges' do
    @rake = Rake::Application.new
    Rake.application = @rake
    @task_name = 'has_badges:distribute_badges'
    
    load File.dirname(__FILE__) + '/../../lib/tasks/has_badges.rake'
    Rake::Task.define_task(:environment)

    @rake[@task_name].wont_equal nil
    HasBadges::Distribution.expects(:distribute_to).with(:all).returns(true)
    @rake[@task_name].invoke
  end
end