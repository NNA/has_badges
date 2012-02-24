require 'rails/generators'
require 'rails/generators/active_record'

class HasBadgesGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  desc "This generator creates Models, migrations used by has_badges"
  source_root File.expand_path('../templates', __FILE__)
  
  argument :user_name, :type => :string, :default => 'User', :banner => 'Name of model that will have badges (default: User)'
  argument :badge_name, :type => :string, :default => 'Badge', :banner => 'Name of model that will handle badges (default: Badge)'
  argument :point_name, :type => :string, :default => 'Point', :banner => 'Name of model that will handle points (default: Point)'

  def initialize(*args, &block)
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
    template 'model/point.rb', "app/models/#{singular_lower_case point_name}.rb"
    template 'model/badge.rb', "app/models/#{singular_lower_case badge_name}.rb"
    template 'model/user_badge.rb', "app/models/#{singular_lower_case user_name}_#{singular_lower_case badge_name}.rb"
  end

  def create_migration
    migration_template 'migration/points.rb', "db/migrate/create_#{plural_lower_case point_name}"
    migration_template 'migration/badges.rb', "db/migrate/create_#{plural_lower_case badge_name}"
    migration_template 'migration/user_badges.rb', "db/migrate/create_#{singular_lower_case user_name}_#{plural_lower_case badge_name}"
  end

end