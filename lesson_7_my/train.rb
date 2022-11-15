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

require_relative 'factory'
require_relative 'instance_counter'
require_relative 'validatable'

class Train
  include Factory
  include InstanceCounter
  include Validatable

  attr_reader :type, :number, :wagons
  attr_accessor :speed, :route, :route_station_index

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @type = type
    @number = number
    @speed = 0
    @route = nil
    @route_station_index = nil
    @wagons = []
    @@trains[number] = self
    register_instance
  end

  def validation_errors
    errors = []
    errors << "Use format XXX-XX for train number" unless @number =~ /^[\p{L}\d]{3}-?[\p{L}\d]{2}$/
    errors << "Specify train type" unless @type
    errors << "Use only #{@type} wagons for #{self}" unless @wagons.all? {|w| w.type == @type }
    errors
  end

  def increase_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    wagons << wagon if speed == 0
    validate!
  end

  def del_wagon
   wagons.pop if speed.zero? && wagons.any?
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
      puts "Already last station"
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
      puts "Already first station"
      return
    end
    current_station.send_train(self)
    self.route_station_index -= 1
    current_station.receive_train(self)
  end

  def next_station
    return nil if route_station_index == route.show_route.size - 1

    route.show_route[route_station_index + 1]
  end

  def prev_station
    return nil if route_station_index == 0

    route.show_route[route_station_index - 1]
  end

  def current_station
   route.show_route[route_station_index]
  end

  def to_s
    out_string = "#{type} train number: #{number} with #{wagons.count} wagons"
    out_string + (@route_station_index ? " on station: #{current_station}" : " not on any route")
  end

  def each_wagon(&block)
    wagons.each(&block)
  end
end
