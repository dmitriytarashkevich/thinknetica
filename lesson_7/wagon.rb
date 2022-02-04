require_relative 'factory'
require_relative 'exception/validation_error'
require_relative 'validate'

class Wagon
  include Factory
  include Validate

  attr_reader :type, :capacity
  attr_accessor :free_capacity

  TYPE = %i[cargo passenger]

  def initialize(type, capacity)
    @type = type
    @capacity = capacity
    @free_capacity = capacity
    validate!
  end

  def take_capacity
    free_capacity.positive? ? self.free_capacity -= 1 : false
  end

  def occupied_capacity
    capacity - free_capacity
  end

  protected

  def validate!
    errors = []
    errors << 'Тип вагона не может быть nil' if type.nil?
    errors << 'Укажите верный тип вагона (:cargo или :passenger)' unless TYPE.include?(type)
    raise ValidationError, errors.join("\n") unless errors.empty?
  end
end
