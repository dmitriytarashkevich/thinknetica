# frozen_string_literal: true

require_relative 'factory'
require_relative 'instances'
require_relative 'validatable'

# Railway train with wagons
class Train
  include Factory
  include Instances
  include Validatable

  attr_reader :type, :number, :wagons
  attr_accessor :speed, :route, :route_station_index

  def self.find(number)
    instances.find { |train| train.number == number }
  end

  def initialize(number, type)
    @type = type
    @number = number
    @speed = 0
    @route = nil
    @route_station_index = nil
    @wagons = []
  end

  def validation_errors
    errors = []
    errors << 'Use format XXX-XX for train number' unless @number =~ /^[\p{L}\d]{3}-?[\p{L}\d]{2}$/
    errors << 'Specify train type' unless @type
    errors << "Use only #{@type} wagons for #{self}" unless @wagons.all? { |w| w.type == @type }
    errors
  end

  def increase_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    wagons << wagon if speed.zero?
    validate!
  end

  def add_new_wagon(capacity)
    add_wagon(self.class::WAGON_TYPE_CLASS.new(capacity))
  end

  def del_wagon
    wagons.pop if speed.zero? && wagons.any?
  end

  def place_to_route(route)
    self.route = route
    self.route_station_index = 0
    current_station.receive_train(self)
  end

  def move_next_station
    raise 'No route' unless route
    raise 'Already last station' unless next_station

    current_station.send_train(self)
    self.route_station_index += 1
    current_station.receive_train(self)
  end

  def move_previous_station
    raise 'No route' unless route
    raise 'Already first station' unless previous_station

    current_station.send_train(self)
    self.route_station_index -= 1
    current_station.receive_train(self)
  end

  def next_station
    return nil if route_station_index == route.stations.count - 1

    route.stations[route_station_index + 1]
  end

  def place_available?
    wagons.any?(&:place_available?)
  end

  def previous_station
    return nil if route_station_index.zero?

    route.stations[route_station_index - 1]
  end

  def current_station
    route.stations[route_station_index]
  end

  def to_s
    out_string = "#{type} train number: #{number} with #{wagons.count} wagons"
    out_string + (@route_station_index ? " on station: #{current_station}" : ' not on any route')
  end

  def each_wagon(&block)
    wagons.each(&block)
  end
end
