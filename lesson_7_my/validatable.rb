module Validatable
  class ValidationError < RuntimeError; end

  def self.included(base)
    base.prepend PrependedMethods
    base.include IncludedMethods
  end

  module PrependedMethods
    def initialize(*args)
      super
      validate!
    end
  end

  module IncludedMethods
    def validate!
      raise ValidationError.new validation_errors.join("\n") unless valid?
    end

    def valid?
      validation_errors.empty?
    end

    def validation_errors
      raise NotImplementedError
    end
  end
end