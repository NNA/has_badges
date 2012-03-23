module HasBadges
  class Helper
    def self.fake_method_instance instance, method_name, fake_value, &block
      instance.instance_exec(fake_value) { |param|
        self.class.send(:define_method, :"new_#{method_name}", proc {param})
        alias :"old_#{method_name}" :"#{method_name}"
        alias :"#{method_name}" :"new_#{method_name}"
      }
      value = block.call
      instance.instance_eval { alias :"#{method_name}" :"old_#{method_name}" }
      value
    end
  end
end