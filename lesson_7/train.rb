#   Класс Train (Поезд):
#   Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
#   Может набирать скорость
#   Может возвращать текущую скорость
#   Может тормозить (сбрасывать скорость до нуля)
#   Может возвращать количество вагонов
#   Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов).
#   Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
#   Может принимать маршрут следования (объект класса Route).
#   При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
#   Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
#   Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

require_relative 'factory'
require_relative 'instance_counter'
require_relative 'exception/validation_error'
require_relative 'meta/validation'
require_relative 'meta/acсessors'

class Train
  include Factory
  include InstanceCounter
  include Validation
  include Acсessors

  REGEX_NUMBER = /^[a-zа-я0-9]{3}(?:-[a-zа-я0-9]{2})?$/i

  attr_reader :number, :wagons
  attr_accessor_with_history :speed, :route, :route_station_index
  strong_attr_accessor :type, Symbol

  validate :number, :presence
  validate :number, :format, REGEX_NUMBER
  validate :type, :presence
  validate :number, :type, String



  TYPE = %i[cargo passenger]

  @@trains = []

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number, type)
    @type = type
    @number = number
    validate!
    @speed = 0
    @route = nil
    @route_station_index = nil
    @wagons = []
    @@trains.push(self)
    register_instance
  end

  def increase_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    wagons << wagon if speed.zero?
  end

  def del_wagon(wagon)
    wagons.delete(wagon) if speed.zero?
  end

  def set_route(route)
    self.route = route
    self.route_station_index = 0
    current_station.receive_train(self)
  end

  def move_next
    unless route
      puts 'No route'
      return
    end
    if route_station_index == route.show_route.size - 1
      puts 'Last station'
      return
    end
    current_station.send_train(self)
    self.route_station_index += 1
    current_station.receive_train(self)
  end

  def move_prev
    unless route
      puts 'No route'
      return
    end
    if route_station_index.zero?
      puts 'First station'
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

  def each_wagon(&block)
    wagons.each { |wagon| block.call(wagon) }
  end

  def each_wagon_with_index(&block)
    wagons.each_with_index(&block)
  end

  protected

 # def validate!
 #   errors = []
 #   errors << 'Параметры не могут быть nil' if number.nil? || type.nil?
 #   errors << 'Укажите верный тип поезда (:cargo или :passenger)' unless TYPE.include?(type)
 #   errors << 'Не верный формат номера поезда' if number !~ REGEX_NUMBER
 #   raise ValidationError, errors.join("\n") unless errors.empty?
 # end
end
