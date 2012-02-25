require "bundler/setup"
require 'active_record'
require 'active_support'

require File.dirname(__FILE__) + '/../lib/has_badges/has_badges_extensions'

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')
fixture_path = File.dirname(__FILE__) + '/fixtures/'
ActiveSupport::Dependencies.autoload_paths << fixture_path
load(File.dirname(__FILE__) + '/schema.rb')

class Helper
  
  @@data_cache = {}
  
  def self.clean_data
    User.destroy_all
    Badge.destroy_all
    UserBadge.destroy_all
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
  
end