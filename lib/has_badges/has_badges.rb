if defined?(Rails) && Rails::VERSION::MAJOR == 3
  module HasBadges
    require 'rails'
    require File.dirname(__FILE__) + '/has_badges_extensions.rb'

    class Railtie < Rails::Railtie
    
      initializer "include HasBadgesExtensions within ORM" do
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.send(:include, HasBadges::HasBadgesExtensions)
        end
      end

      rake_tasks do
        Dir.glob(File.join(File.dirname(__FILE__), '../tasks/*.rake')).each { |r| import r }
      end
    
    end
  end
else
  puts 'ERROR: has_badges needs Rails > 3, please execute \'gem install rails\' if you want to use has_badges'
end