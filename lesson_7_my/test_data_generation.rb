# frozen_string_literal: true

# Generates test data
module TestDataGeneration
  def initialize(*args)
    generate_stations
    generate_routes(4)
    generate_trains_with_wagons(3)
    assign_routes_for_trains
    super
  end

  private

  def generate_stations
    %w[Minsk Brest Baranovichi Orsha Pinsk Vitebsk Molodechno].each { |name| Station.new(name) }
  end

  def generate_routes(number_of_routes)
    number_of_routes.times do
      stations = Station.instances
      start_station = stations.sample
      end_station = (stations - [start_station]).sample
      mid_station = (stations - [start_station, end_station]).sample
      Route.new(start_station, end_station).add_mid_station(mid_station)
    end
  end

  def generate_trains_with_wagons(count)
    names = %w[fl1z6 KbB-b6 2dB-05 soz5h l6q-PY nYk9O Sf4o3 9l1tG rbili hcsXR]
    count.times do
      type = [TrainCargo, TrainPassenger].sample
      train = type.new(names.pop)
      rand(1..5).times do
        train.add_wagon(train.class::WAGON_TYPE_CLASS.new(rand(1..10) * 10))
      end
    end
  end

  def assign_routes_for_trains
    Train.instances.each do |train|
      train.place_to_route(Route.instances.sample)
    end
  end
end
