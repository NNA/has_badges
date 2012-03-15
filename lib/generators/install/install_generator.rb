require 'rails/generators'
require 'rails/generators/active_record'
module HasBadges
  class HasBadgesGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    
    desc "This generator creates Models, migrations used by has_badges"
    source_root File.expand_path('../templates', __FILE__)
    
    argument :no_migration,  :type => :string, :default => false
    argument :no_model,      :type => :string, :default => false
    argument :migration_dir, :type => :string, :default => false
    
    argument :user_name, :type => :string, :default => 'User', :banner => 'Name of model that will have badges (default: User)'
    argument :badge_name, :type => :string, :default => 'Badge', :banner => 'Name of model that will handle badges (default: Badge)'
    argument :point_name, :type => :string, :default => 'Point', :banner => 'Name of model that will handle points (default: Point)'
    argument :achievement_name, :type => :string, :default => 'Achievement', :banner => 'Name of model that will handle possible achievements (default: Achievement)'

    def initialize(*args, &block)
      @@no_model      = false
      @@migration_dir = "db/migrate"
      if args[1].first # TODO : can't we retrieve argument no_model instead of this ugly hack ?
        @@no_model      = (args[1].first.scan(/no_model=(\w*)/).first.first == 'true')
        @@migration_dir = args[1].first.scan(/migration_dir='(.*)'/).first.first
      end
      super
    end

    def manifest
      create_model_files
      create_migration        
    end

    def self.next_migration_number dirname
      ActiveRecord::Generators::Base.next_migration_number dirname
    end
    
    private

    def singular_camel_case name
      name.singularize.camelize
    end

    def plural_camel_case name
      name.pluralize.camelize
    end

    def singular_lower_case name
      name.singularize.underscore
    end
    
    def plural_lower_case name 
      name.pluralize.underscore
    end
    
    def create_model_files
      unless @@no_model
        template 'model/point.rb', "app/models/#{singular_lower_case point_name}.rb"
        template 'model/badge.rb', "app/models/#{singular_lower_case badge_name}.rb"
        template 'model/user_badge.rb', "app/models/#{singular_lower_case user_name}_#{singular_lower_case badge_name}.rb"
        template 'model/achievement.rb', "app/models/#{singular_lower_case achievement_name}.rb"
      end
    end

    def create_migration 
      @@migration_dir ||= "db/migrate"
      migration_template 'migration/points.rb', "#{@@migration_dir}/create_#{plural_lower_case point_name}"
      migration_template 'migration/badges.rb', "#{@@migration_dir}/create_#{plural_lower_case badge_name}"
      migration_template 'migration/user_badges.rb', "#{@@migration_dir}/create_#{singular_lower_case user_name}_#{plural_lower_case badge_name}"
      migration_template 'migration/achievements.rb', "#{@@migration_dir}/create_#{plural_lower_case achievement_name}"
    end

  end
end