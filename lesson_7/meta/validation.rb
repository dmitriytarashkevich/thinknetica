module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr, rule, option = nil)
      validation_rules[attr] = [] if validation_rules[attr].nil?
      validation_rules[attr] << [rule, option]
    end

    def validation_rules
      @validation_rules ||= {}
    end
  end

  module InstanceMethods
    def validate!
      self.class.validation_rules.each do |attr, rules|
        value = instance_variable_get("@#{attr}".to_sym)
        rules.each { |rule| send("valid_#{rule[0]}?", value, *rule[1]) }
      end
    end

  protected
    def valid_presence?(value)
      raise ValidationError, "Поле не может быть пустым или nil" if value.nil? || value.empty?
    end

    def valid_type?(value, type)
      raise ValidationError, "Поле должно быть #{type}" unless value.is_a? type
    end

    def valid_format?(value, format)
      raise ValidationError, "Значение #{value} не соответствует формату #{format}" unless value =~ format
    end
  end
end