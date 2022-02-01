require_relative 'factory'
require_relative 'exception/validation_error'
require_relative 'validate'

class Wagon
  include Factory
  include Validate  

  attr_reader :type

  TYPE = %i[cargo passenger]

  def initialize(type)
    @type = type
    validate!
  end

  protected

  def validate!
    errors = []
    errors << "Тип вагона не может быть nil" if type.nil?
    errors << "Укажите верный тип вагона (:cargo или :passenger)" unless TYPE.include?(type)
    raise ValidationError.new errors.join("\n") unless errors.empty?
  end
end
