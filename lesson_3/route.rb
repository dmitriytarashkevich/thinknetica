=begin
  Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций. 
  Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
  attr_reader :start_station, :end_station, :mid_stations

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @mid_stations = []
  end

  def add_mid_station(station)
    @mid_stations << station
  end

  def show_route
    [@start_station, @end_station].insert(1, *self.mid_stations)
  end
end
