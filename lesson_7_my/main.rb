require_relative 'interactive_console_tools.rb'
require 'io/console'

require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_passenger'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_passenger'

class Main

  include InteractiveConsoleTools

  def initialize
    @trains = []
    @wagons_cargo = []
    @wagons_passenger = []
    @routes = []
    @stations = []

    minsk = Station.new("Minsk")
    brest = Station.new("Brest")
    baranovichi = Station.new("Baranovichi")
    orsha = Station.new("Orsha")
    @stations = [minsk, brest, baranovichi, orsha]

    brest_minsk_route = Route.new(brest, minsk)
    brest_minsk_route.add_mid_station(baranovichi)
    minsk_orsha_route = Route.new(minsk, orsha)
    @routes = [brest_minsk_route, minsk_orsha_route]

    @wagons_cargo = [WagonCargo.new(100)]
    @wagons_passenger = [WagonPassenger.new(80), WagonPassenger.new(55)]
    train_cargo_1984 = TrainCargo.new("123-qw")
    train_cargo_1984.add_wagon(@wagons_cargo[0])
    @trains << train_cargo_1984
    train_passenger_1408 = TrainPassenger.new("456as")
    train_passenger_1408.add_wagon(@wagons_passenger[0])
    @trains << train_passenger_1408

    train_cargo_1984.set_route(brest_minsk_route)
    train_passenger_1408.set_route(minsk_orsha_route)
  end

  def show_menu
    system "clear"
    loop do
      menu_action = select_using_console("menu item", MENU)
      return if menu_action == 'terminate_program'

      begin
        self.send(menu_action)
      rescue NothingToSelectException => e
        puts e.message
      end
      continue_story
    end
  end

private

attr_reader :trains, :wagons_cargo, :wagons_passenger, :routes, :stations

  MENU = %w[
    terminate_program
    create_station
    create_cargo_train
    create_passenger_train
    create_route
    add_station_to_route
    assign_route_for_train
    add_wagon_to_train
    remove_wagon_from_train
    move_train_on_its_route
    show_list_of_stations
    show_list_of_trains_on_station
    show_stations_with_trains
    take_place_in_wagon
  ]

  def create_station
    name = prompt("station name")
    stations << Station.new(name)
    puts "Station '#{name}' created"
  end

  def create_cargo_train
    create_train(TrainCargo)
  end

  def create_passenger_train
    create_train(TrainPassenger)
  end

  def create_train(trainClass)
    begin
      new_train = trainClass.new(prompt("train number"))
    rescue Validatable::ValidationError => e
      puts e.message
      retry
    end
    trains << new_train
    puts "Created: #{new_train}"
  end

  def create_route
    start_station = select_using_console("start station", stations)
    (other_stations = stations.dup).delete(start_station)
    end_station = select_using_console("end station", other_stations)
    new_route = Route.new(start_station, end_station)
    routes << new_route
    puts "Created: #{new_route}"
  end

  def add_station_to_route
    selected_route = select_using_console(routes)
    other_stations = stations - selected_route.stations
    selected_route.add_mid_station(select_using_console("other station", other_stations))
    puts "Updated #{selected_route}"
  end

  def assign_route_for_train
    selected_train = select_using_console("train", trains)
    selected_route = select_using_console(routes)
    selected_train.set_route(selected_route)
    puts "#{selected_train} added to #{selected_route}"
  end

  def show_list_of_station7s
    puts "Stations list"
    show_list_of(stations)
  end

  def show_list_of_trains_on_station
    show_list_of(select_using_console(stations).trains)
  end

  def add_wagon_to_train
    selected_train = select_using_console("train", trains)
    selected_train.add_new_wagon(prompt("capacity").to_i)
    puts "Wagon added to #{selected_train}"
  end

  def remove_wagon_from_train
    selected_train = select_using_console("train with wagons", trains.filter { |t| t.wagons.any? })
    selected_train.del_wagon
    puts "Wagon removed from #{selected_train}"
  end

  def move_train_on_its_route
    selected_train = select_using_console("train on route", trains.filter(&:route))
    actions = ["Move next station", "Move previous station"]
    selected_action = select_using_console("train direction", actions)
    selected_train.send(selected_action.gsub(' ', '_').downcase)
    puts selected_train
  end

  def show_stations_with_trains
    stations.each do |station|
      puts station
      station.each_train do |t|
        puts t
        t.each_wagon { |w| puts w }
      end
    end
  end

  def take_place_in_wagon
    selected_train = select_using_console(trains.filter do |t|
      t.wagons.any? { |w| w.free_place.positive? }
    end)
    selected_wagon = select_using_console(selected_train.wagons)

    if selected_wagon.type == :cargo
      filled_place = selected_wagon.fill_place(prompt("volume of cargo").to_i)
    else
      filled_place = selected_wagon.fill_place
    end
    puts (filled_place ? "Took place in #{selected_wagon}" : "Try again")
  end

end

Main.new.show_menu