require "bundler/setup"
require 'minitest/spec'
require 'active_record'
require 'active_support'
require 'mocha'
require 'fileutils'

require File.dirname(__FILE__) + '/../lib/has_badges/distribution'
require File.dirname(__FILE__) + '/../lib/has_badges/helper'
require File.dirname(__FILE__) + '/../lib/has_badges/has_badges_extensions'

#Load AR Models
model_path = File.dirname(__FILE__) + '/../lib/generators/install/templates/model/'
ActiveSupport::Dependencies.autoload_paths << model_path
fixture_path = File.dirname(__FILE__) + '/fixtures/'
ActiveSupport::Dependencies.autoload_paths << fixture_path

#Load migrations using has_badge_generator
require 'has_badges' # require only generator if possible
FileUtils.rm_rf './tmp/db'
silence :stdout do
  Rails::Generators.invoke("has_badges", ['', "--no_model=true --migration_dir='./tmp/db'"])
end
Dir['**/*.rb'].keep_if{|a|a[0..5]=='tmp/db'}.each do |file|
  require_relative "../#{file}"
end
require_relative "fixtures/users_migration.rb"

# Loading database by running migrations and fixtures
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')
silence :stdout do
  CreateUsers.new.change
  CreatePoints.new.change
  CreateBadges.new.change
  CreateUserBadges.new.change
  CreateAchievements.new.change
end

class DryFactory
  @@data_cache = {}
  @@required_fields_hash = {
    user:       { login: "user_name1" },
    badge:      { name:  "badge_name1", points_required: 0 },
    user_badge: { user_id: 1, badge_id: 1 },
    point:      { user_id: 1, 
                  amount: 1,
                  date: Time.now }
  }

  def self.access_as_class_vars_from callerInstance, contexts 
    contexts.each do |context|
      if @@data_cache[context].nil?
        DryFactory.class_variable_set("@@data_cache", 
                                  @@data_cache.merge({context => callerInstance.send(context)}))
      end
      @@data_cache[context].each_pair do |k, v|
        callerInstance.instance_variable_set "@#{k}", v
      end
    end
  end

  def self.build klass, options = {}
    eval(klass.to_s.classify).new(@@required_fields_hash[klass].merge(options))
  end

  def self.build_stubbed klass, options = {}
    builded = eval(klass.to_s.classify).new(@@required_fields_hash[klass])
    options.each {|k,v| builded.stubs(k).returns(v) }
    builded
  end

  def self.create klass, options = {}
    self.build(klass, options).tap(&:save)
  end

  def self.create_user(options = {})
    User.create({:login => "user_name1"}.merge(options))
  end

  def self.create_badge(options = {})
    Badge.create({:name => "badge_name1"}.merge(options))
  end

  def self.create_user_badge(options = {})
    UserBadge.create({:user_id  => 1,
    			            :badge_id => 1}.merge(options))
  end

  def self.create_user_point(options = {})
    Point.create({:user_id  => 1, 
                  :amount => 1,
                  :date => Time.now}.merge(options))
  end

  def self.only_for_this_test &block
    begin
      result = block.call
    ensure
      result.destroy if result
    end
  end

  def self.rollback_after_block &block
    ActiveRecord::Base.transaction do
      begin
        yield
        raise ActiveRecord::Rollback, "rollback after block"
      end
    end
  end
  
end