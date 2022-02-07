#   Класс Route (Маршрут):
#   Имеет начальную и конечную станцию, а также список промежуточных станций.
#   Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
#   Может добавлять промежуточную станцию в список
#   Может удалять промежуточную станцию из списка
#   Может выводить список всех станций по-порядку от начальной до конечной

require_relative 'exception/validation_error'
require_relative 'meta/validation'
require_relative 'meta/acсessors'

class Route
  include Validation
  include Acсessors

  attr_accessor :stations

  validate :stations, :presence

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    validate!
  end

  def add_mid_station(station)
    @stations.insert(-2, station)
  end

  def first
    stations.first
  end

  def last
    stations.last
  end

  def show_route
    stations
  end

  protected

#  def validate!
#    errors = []
#    errors << 'Станция не должна быть nil:' if stations.include? nil
#    errors << 'Не верный тип данных, ожидается Station.class' unless stations.all?(Station)
#   errors << 'Начальная и конечная станция должны быть разные' if first == last
#    raise ValidationError, errors.join("\n") unless errors.empty?
# end
end
