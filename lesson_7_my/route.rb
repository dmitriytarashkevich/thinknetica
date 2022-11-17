=begin
  Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций. 
  Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

require_relative 'instances'
require_relative 'validatable'

class Route
  include Validatable
  include Instances

  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def validation_errors
    errors = []
    errors << "Specify start-end stations" unless @stations.all?(Station)
    errors
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

  def to_s
    "Route #{first.name} -> #{last.name} (intermediates: #{(stations - [first, last]).join(', ')})"
  end
end
