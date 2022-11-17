# frozen_string_literal: true

require_relative 'instances'
require_relative 'validatable'

# Route between stations
class Route
  include Validatable
  include Instances

  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def validation_errors
    errors = []
    errors << 'Specify start-end stations' unless @stations.all?(Station)
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

  def to_s
    "Route #{first.name} -> #{last.name} (intermediates: #{(stations - [first, last]).join(', ')})"
  end
end
