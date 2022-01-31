require_relative 'factory'
require_relative 'exception/validation_error'

class Wagon
  include Factory
  
  attr_reader :type

  TYPE = %i[cargo passenger]

  def initialize(type)
    @type = type
    validate!
  end

  def valid?
    validate! rescue return false
    true
  end

  protected

  def validate!
    raise ValidationError, "Тип вагона не может быть nil" if type.nil?
    raise ValidationError, "Укажите верный тип вагона (:cargo или :passenger)" unless TYPE.include?(type)
  end
end
