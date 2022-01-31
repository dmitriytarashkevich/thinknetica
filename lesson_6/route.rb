=begin
  Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций. 
  Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

require_relative 'exception/validation_error'

class Route
  attr_reader :stations

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
  
  def valid?
    validate! rescue return false
    true
  end

  protected
  
  def validate!
    raise ValidationError, "Станция не должна быть nil:" if stations.include? nil
    raise ValidationError, "Не верный тип данных, ожидается Station.class" unless stations.all?(Station)
    raise ValidationError, "Начальная и конечная станция должны быть разные" if first == last
  end
end
