namespace :has_badges do
  desc "Refreshes Badges for all users"
  task :distribute_badges => :environment do
  	puts 'Starting badge distribution'
    # errors = []
    HasBadges::Distribution.distribute_to(:all)
    # names.each do |name|
    #   # Paperclip.each_instance_with_attachment(klass, name) do |instance|
    #   #   instance.send(name).reprocess!(*styles)
    #   #   errors << [instance.id, instance.errors] unless instance.errors.blank?
    #   # end
    #   puts 'toto'
    # end
    # errors.each{|e| puts "#{e.first}: #{e.last.full_messages.inspect}" }
    puts 'Done badge distribution'
  end
end