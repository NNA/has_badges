# require File.dirname(__FILE__) + '/../lib/generators/install/templates/install_generator.rb'
require 'has_badges'
# include HasBadges::HasBadgesGenerator

ActiveRecord::Schema.define(:version => 2) do  
  #HasBadges::HasBadgesGenerator.invoke 'create_migration', ['achievements']
  #HasBadges::HasBadgesGenerator.new.send(:create_migration)

  # create_table "users", :force => true do |t|
  #   t.string   "login"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

  # create_table "badges", :force => true do |t|
  #   t.string   "name"
  #   t.integer  "required_points"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

  # create_table "user_badges", :force => true do |t|
  #   t.integer  "user_id"
  #   t.integer  "badge_id"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

  # create_table "points", :force => true do |t|
  #   t.integer  "user_id"
  #   t.integer  "amount"
  #   t.string   "reason"
  #   t.datetime "date"
  #   t.boolean  "used"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

  # create_table "achievements", :force => true do |t|
  #   t.string   "name"
  #   t.integer  "points_rewarded"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

end