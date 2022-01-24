=begin
  Класс Train (Поезд):
  Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
  Может набирать скорость
  Может возвращать текущую скорость
  Может тормозить (сбрасывать скорость до нуля)
  Может возвращать количество вагонов
  Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). 
  Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  Может принимать маршрут следования (объект класса Route). 
  При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end

class Train
   
  attr_reader :type, :number   
  attr_accessor :speed, :route, :route_station_index, :number_of_wagons

  def initialize(number, type, number_of_wagons)
    raise "Укажите верный тип поезда (:freight или :passenger)" unless [:freight, :passenger].include?(type)
    @type = type 
    @number = number
    @number_of_wagons = number_of_wagons
    @speed = 0
    @route = nil
    @route_staion_index = nil
  end

  def increase_speed(speed)
    self.speed += speed 
  end

  def stop
    self.speed = 0
  end 

  def add_wagon
    self.number_of_wagons += 1 if speed == 0
  end

  def del_wagon
   self.number_of_wagons -= 1 if number_of_wagons >= 1 && speed == 0
  end 

  def set_route(route)
   self.route = route
   self.route_station_index = 0
   current_station.receive_train(self)
  end
  
  def move_next
    unless route 
      puts "No route"
      return
    end
    if route_station_index == route.show_route.size - 1
      puts "Last station"
      return
    end
    current_station.send_train(self)
    self.route_station_index += 1
    current_station.receive_train(self)
  end

  def move_prev
    unless route
      puts "No route"
      return
    end
    if route_station_index == 0
      puts "First station"
      return
    end
    current_station.send_train(self)
    self.route_station_index -= 1
    current_station.receive_train(self)
  end

  def next_station
    return if route_station_index == route.show_route.size - 1
  
    route.show_route[route_station_index + 1]
  end

  def prev_station
    return if route_station_index == 0
 
    route.show_route[route_station_index - 1]
  end

  def current_station
   route.show_route[route_station_index]
  end
end
