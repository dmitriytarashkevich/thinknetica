=begin
  Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций. 
  Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
  attr_reader :stations, :mid_stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    @mid_stations = []
  end

  def add_mid_station(station)
    @mid_stations << station
  end
  
  def first
    stations[0]
  end

  def last
    stations[1]
  end

  def show_route
    [first, *self.mid_stations, last]
  end
end
