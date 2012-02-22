require "bundler/setup"
require 'active_record'
require 'active_support'
require 'minitest/autorun'

require File.dirname(__FILE__) + '/../lib/level_up/has_badges_extensions'

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')
fixture_path = File.dirname(__FILE__) + '/fixtures/'
ActiveSupport::Dependencies.autoload_paths << fixture_path
load(File.dirname(__FILE__) + '/schema.rb')

class Helper  
  
  def self.before_all &block
    yield
  end

  def self.clean_data
    User.destroy_all
    Badge.destroy_all
    UserBadge.destroy_all
  end

  def self.create_user(options = {})
    User.create({:login => "Nicolas"}.merge(options))
  end

  def self.create_badge(options = {})
    Badge.create({:name => "Newbie"}.merge(options))
  end

  def self.create_user_badge(options = {})
    UserBadge.create({:user_id  => self.create_user({:login => 'user_name1'}),
    			            :badge_id => self.create_badge({:name  => 'badge_name1'})}.merge(options))
  end
#   # def create_message(options = {})
#   #   return Message.create({:sender => @george,
#   #                          :recipient => @jerry,
#   #                          :subject => "Frolf, Jerry!",
#   #                          :body => "Frolf, Jerry! Frisbee golf!"}.merge(options))
#   # end
  
end