module Instances
  def self.included(base)
    base.extend ClassMethods
    base.prepend InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def instances_count
      instances.count
    end

    def add_instance_recursively(instance)
      (@instances ||= []) << instance
      superclass.add_instance_recursively(instance) if superclass.respond_to?(:instances)
    end
  end

  module InstanceMethods
    def initialize(*args)
      super
      self.class.add_instance_recursively(self)
    end
  end
end