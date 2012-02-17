require 'rails/generators'

class LevelUpGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  desc "This generator creates Models, migrations used by level_up"
  source_root File.expand_path('../templates', __FILE__)
  
  argument :user_name, :type => :string, :default => 'User', :banner => 'Name of model that will have badges (default: User)'
  argument :point_name, :type => :string, :default => 'Point', :banner => 'Name of model that will handle points (default: Point)'

  def initialize(*args, &block)
    super
  end

  def manifest
    create_model_files
    create_migration        
  end

  def self.next_migration_number name
    Time.now.strftime '%Y%m%d%H%M%S'
  end
  
  private
  
  def create_model_files
    template 'model/points.rb', "app/models/#{point_name.downcase.pluralize}.rb"
  end

  def create_migration
    migration_template 'migration/points.rb', "db/migrate/create_#{point_name.downcase.pluralize}"
  end
end