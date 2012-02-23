if defined?(Rails) && Rails::VERSION::MAJOR == 3
  module LevelUp
    require 'rails'
    require File.dirname(__FILE__) + '/has_badges_extensions.rb'

    class Railtie < Rails::Railtie
    
       initializer "include HasBadgesExtensions within ORM" do
         ActiveSupport.on_load(:active_record) do
           ActiveRecord::Base.send(:include, LevelUp::HasBadgesExtensions)
         end
       end
    
    end
  end
end