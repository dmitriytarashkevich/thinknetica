# frozen_string_literal: true

# List of available actions when interacting with console
module MenuActions
  def create_station
    new_station = Station.new(prompt('station name'))
    puts "Station '#{new_station}' created"
  end

  def create_cargo_train
    create_train(TrainCargo)
  end

  def create_passenger_train
    create_train(TrainPassenger)
  end

  def create_route
    start_station = select_using_console(Station, 'start station')
    (other_stations = Station.instances.dup).delete(start_station)
    end_station = select_using_console(other_stations, 'end station')
    new_route = Route.new(start_station, end_station)
    puts "Created: #{new_route}"
  end

  def add_station_to_route
    selected_route = select_using_console(Route)
    other_stations = Station.instances - selected_route.stations
    selected_route.add_mid_station(select_using_console(other_stations, 'other station'))
    puts "Updated #{selected_route}"
  end

  def assign_route_for_train
    selected_train = select_using_console(Train)
    selected_route = select_using_console(Route)
    selected_train.place_to_route(selected_route)
    puts "#{selected_train} added to #{selected_route}"
  end

  def show_list_of_stations
    puts 'Stations list'
    show_list_of(Station.instances)
  end

  def show_list_of_trains_on_station
    show_list_of(select_using_console(Station).trains)
  end

  def add_wagon_to_train
    selected_train = select_using_console(Train)
    selected_train.add_new_wagon(prompt('capacity').to_i)
    puts "Wagon added to #{selected_train}"
  end

  def remove_wagon_from_train
    trains_with_wagons = Train.instances.filter { |t| t.wagons.any? }
    selected_train = select_using_console(trains_with_wagons, 'train with wagons')
    selected_train.del_wagon
    puts "Wagon removed from #{selected_train}"
  end

  def move_train_on_its_route
    selected_train = select_using_console(Train.instances.filter(&:route), 'train on route')
    actions = ['Move next station', 'Move previous station']
    selected_action = select_using_console(actions, 'train direction')
    selected_train.send(selected_action.gsub(' ', '_').downcase)
    puts "Moved: #{selected_train}"
  end

  def show_list_of_stations_with_trains
    Station.instances.each do |station|
      next unless station.trains.any?

      puts station
      station.each_train do |t|
        puts t
        t.each_wagon { |w| puts w }
      end
    end
  end

  def take_place_in_wagon
    trains_with_free_place = Train.instances.filter(&:place_available?)
    selected_train = select_using_console(trains_with_free_place, 'train with free place')
    wagons_with_free_place = selected_train.wagons.filter(&:place_available?)
    selected_wagon = select_using_console(wagons_with_free_place, 'wagon with free place')
    filled_place = if selected_wagon.type == :cargo
                     selected_wagon.fill_place(prompt('volume of cargo').to_i)
                   else
                     selected_wagon.fill_place
                   end
    puts(filled_place ? "Took place in #{selected_wagon}" : 'Try again')
  end

  private

  def create_train(train_class)
    puts "Created: #{train_class.new(prompt('train number'))}"
  rescue Validatable::ValidationError => e
    puts e.message
    retry
  end
end
