namespace :has_badges do
  
  task :require => :environment do
    begin
      require 'has_badges'
    rescue LoadError => e
      raise e
    end
  end

  desc "Refreshes Badges for all users"
  task :distribute_badges => ['has_badges:require'] do |t, args|
  	puts "Badge distribution: Started at #{Time.now}"
    HasBadges::Distribution.distribute_badges
    puts "Badge distribution: Ended at #{Time.now}"
  end
end