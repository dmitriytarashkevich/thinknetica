module Acсessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*attrs)
      attrs.each do |attr|
        define_method("#{attr}_history") { instance_variable_get("@#{attr}_history".to_sym) }
        define_method(attr) { instance_variable_get "@#{attr}".to_sym }
        define_method("#{attr}=") do |value|
          instance_variable_set "@#{attr}_history".to_sym, [] if instance_variable_get("@#{attr}_history".to_sym).nil?
          instance_variable_get("@#{attr}_history".to_sym) << value
          instance_variable_set "@#{attr}".to_sym, value
        end
      end
    end

    def strong_attr_accessor(attr, type)
      define_method(attr) { instance_variable_get "@#{attr}".to_sym }
      define_method("#{attr}=") do |value|
        raise TypeError, "For @#{attr} should be #{type}" unless value.is_a?(type)

        instance_variable_set "@#{attr}".to_sym, value
      end
    end
  end
end