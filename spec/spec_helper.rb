require "bundler/setup"
require 'minitest/spec'
require 'active_record'
require 'active_support'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/has_badges/distribution'
require File.dirname(__FILE__) + '/../lib/has_badges/has_badges_extensions'

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')

model_path = File.dirname(__FILE__) + '/../lib/generators/install/templates/model/'
ActiveSupport::Dependencies.autoload_paths << model_path

fixture_path = File.dirname(__FILE__) + '/fixtures/'
ActiveSupport::Dependencies.autoload_paths << fixture_path

load(File.dirname(__FILE__) + '/schema.rb')

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
  
  def self.clean_data
    User.destroy_all
    Badge.destroy_all
    UserBadge.destroy_all
  end


  def self.build klass, options = {}
    @time = Benchmark.measure do
      puts "klass #{klass}"
      eval(klass.to_s.classify).new(@@required_fields_hash[klass].merge(options))
    end
    puts "-------------------------------------------------------#{@time}"
  end

  def self.create klass, options = {}
    # puts "klass#{klass}"
    # puts "options#{options}"
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
    # ActiveRecord::Base.transaction do
      begin
        result = block.call
      ensure
        result.destroy if result
      end
    # end
  end
  
end