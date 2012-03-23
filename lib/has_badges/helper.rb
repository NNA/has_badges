module HasBadges
  class Helper
  	def self.toto
      'toto'
    end

    def self.fake_method_instance instance, method_name, fake_value, &block
      puts "starting fake #{method_name} with #{fake_value}"
      # puts "before fake #{eval(instance).instance_exec(fake_value)}"
      puts "before fake #{instance.send(method_name.to_sym)}"
      instance.instance_exec(fake_value) { |param|
        @new_val = param
        def new_points
          @new_val
        end
        alias :old_points :points
        alias :points :new_points
        # alias "old_#{method_name}".to_sym method_name.to_sym
        # alias method_name.to_sym "new_#{method_name}".to_sym }
      }
      puts "after fake #{instance.send(method_name.to_sym)}"

      value = block.call
      puts "returned_value: #{value}" 
      instance.instance_eval { alias :points :old_points }
      puts "rolledback to old value #{instance.send(method_name.to_sym)}"
      value
      # User.send(:define_method, 'points', proc {user_points})
      # user.instance_exec(user_points) { |param|
      #   @new_points = param
      #   def new_points
      #     @new_points
      #   end
      #   alias :old_points :points
      #   alias :points :new_points }
      # puts "before in #{user.points}"
      # user.instance_eval { alias :points :old_points }
    end
  end
end