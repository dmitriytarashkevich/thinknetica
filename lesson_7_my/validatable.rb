# frozen_string_literal: true

# Validates new objects according possible validation_errors, adds valid? interface
module Validatable
  class ValidationError < RuntimeError; end

  def self.included(base)
    base.prepend PrependedMethods
    base.include IncludedMethods
  end

  # methods to prepend
  module PrependedMethods
    def initialize(*args)
      super
      validate!
    end
  end

  # methods to include
  module IncludedMethods
    def validate!
      raise ValidationError, validation_errors.join("\n") unless valid?
    end

    def valid?
      validation_errors.empty?
    end

    def validation_errors
      raise NotImplementedError
    end
  end
end
