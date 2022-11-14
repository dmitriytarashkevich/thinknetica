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

  def initialize
    @trains = []
    @wagons_cargo = []
    @wagons_passenger = []
    @routes = []
    @stations = []
    #
    # minsk = Station.new("Minsk")
    # brest = Station.new("Brest")
    # baranovichi = Station.new("Baranovichi")
    # orsha = Station.new("Orsha")
    # @stations = [minsk, brest, baranovichi, orsha]
    #
    # brest_minsk_route = Route.new(brest,minsk)
    # brest_minsk_route.add_mid_station(baranovichi)
    # minsk_orsha_route = Route.new(minsk,orsha)
    # @routes = [brest_minsk_route,minsk_orsha_route]
    #
    # @wagons_cargo = [WagonCargo.new(100)]
    # @wagons_passenger = [WagonPassenger.new(80),WagonPassenger.new(55)]
    # train_cargo_1984 = TrainCargo.new("123-qw")
    # train_cargo_1984.add_wagon(@wagons_cargo[0])
    # @trains << train_cargo_1984
    # train_passenger_1408 = TrainPassenger.new("456as")
    # train_passenger_1408.add_wagon(@wagons_passenger[0])
    # @trains << train_passenger_1408
    #
    # train_cargo_1984.set_route(brest_minsk_route)
  end

  def show_menu
    system "clear"
    loop do
      MENU.each_with_index {|el, i| puts "#{i} - #{el.gsub("_", " ").capitalize}"}
      menu_key = gets.chomp.to_i
      return if menu_key.zero?

      self.send(MENU[menu_key])
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
    show_list_of_trains
  ]

  def create_station
    print "Enter station name: "
    name = gets.chomp
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
      print "Enter train number: "
      new_train = trainClass.new(gets.chomp)
    rescue Validatable::ValidationError => e
      puts e.message
      retry
    end
    trains << new_train
    puts "Created: #{new_train}"
  end

  def create_route
    if stations.size > 1
      puts "Select start station: "
      show_list_of(stations)
      index = gets.chomp.to_i - 1
      start_station = stations[index]
      puts "Select end station: "
      stations_dup = stations.dup
      stations_dup.delete(start_station)
      show_list_of(stations_dup)
      index = gets.chomp.to_i - 1
      end_station = stations_dup[index]
      routes << Route.new(start_station, end_station)
      puts "Created route - from #{start_station} to #{end_station}"
    else
      puts "ERROR - You have #{stations.size} stations. Create at least 2 for creating a route"
    end
  end

  def add_station_to_route
    if routes.any?
      puts "Select route"
      show_list_of(routes)
      index = gets.chomp.to_i - 1
      selected_route = routes[index]
      stations_dup = stations.dup
      stations_dup = stations_dup.delete_if { |st| selected_route.show_route.include?(st) }
      if stations.any?
        puts "Select station for adding to route"
        show_list_of(stations_dup)
        index = gets.chomp.to_i - 1
        selected_route.add_mid_station(stations_dup[index])
        puts "Updated #{selected_route}"
      else
        puts "ERROR - No available stations. Create new"
      end
    else
      puts "ERROR - No available routes. Create new"
    end
  end

  def assign_route_for_train
    if trains.any?
      puts "Select train"
      show_list_of(trains)
      index = gets.chomp.to_i - 1
      selected_train = trains[index]
      if routes.any?
        puts "Select route"
        show_list_of(routes)
        index = gets.chomp.to_i - 1
        selected_route = routes[index]
        selected_train.set_route(selected_route)
        puts "#{selected_train} added to #{selected_route}"
      else
        puts "ERROR - No available routes. Create new"
      end
    else
     puts "ERROR - No available trains. Create new"
    end
  end

  def show_list_of_stations
   puts "Stations list"
   show_list_of(stations)
  end

  def show_list_of_trains
    puts "Select station"
    show_list_of(stations)
    index = gets.chomp.to_i - 1
    selected_station = stations[index]
    puts "Trains list on station: "
    show_list_of(selected_station.trains)
  end

  def add_wagon_to_train
    selected_train = select(trains)
    selected_train.add_wagon(selected_train.class::WAGON_TYPE_CLASS.new)
    puts "Wagon added to #{selected_train}"
  end

  def remove_wagon_from_train
    selected_train = select(trains.filter{|t| t.wagons.any?})
    if selected_train.del_wagon
      puts "Wagon removed from #{selected_train}"
    else
      puts "Train already has no wagons"
    end
  end

  def move_train_on_its_route
    selected_train = select(trains.filter(&:route))
    puts "Select train direction"
    puts "1. Forward"
    puts "2. Backward"
    action = gets.chomp
    case action
      when "1"
        selected_train.move_next
      when "2"
        selected_train.move_prev
    end
    puts selected_train
  end

  def select(trains)
    puts "Select train"
    show_list_of(trains)
    index = gets.chomp.to_i - 1
    trains[index]
  end

  def show_list_of(list)
    list.each_with_index { |el, i| puts "#{i + 1} - #{el}" }
  end

  def continue_story
    puts "_____________________________"
    puts "press any key to continue..."
    puts "_____________________________"
    STDIN.getch
    system "clear"
  end
end

Main.new.show_menu