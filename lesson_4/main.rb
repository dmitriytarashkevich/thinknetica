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
    @trains_cargo = []
    @trains_passenger = []
    @wagons_cargo = []
    @wagons_passenger = []
    @routes = []
    @stations = []
  end

  def show_menu
    system "clear"
    loop do
      puts "0 - ВЫХОД"
      MENU_STATION.each {|k, v| puts "#{k} - #{v[:text]}"}
      menu_key = gets.chomp
      return if menu_key == "0"
      self.send(MENU_STATION[menu_key][:method])
      system "clear"
    end
  end

private

attr_reader :trains_cargo, :trains_passenger, :wagons_cargo, :wagons_passenger, :routes, :stations

  MENU_STATION = {
    '1' => { :text => "СОЗДАТЬ СТАНЦИЮ", :method => 'create_station' },
    '2' => { :text => "СОЗДАТЬ ГРУЗОВОЙ ПОЕЗД", :method => 'create_cargo_train' },
    '3' => { :text => "СОЗДАТЬ ПАССАЖИРСКИЙ ПОЕЗД", :method => 'create_passenger_train' },
    '4' => { :text => "СОЗДАТЬ МАРШРУТ", :method => 'create_route' },
    '5' => { :text => "ДОБАВИТЬ СТАНЦИЮ В МАРШРУТ", :method => 'add_station_to_route' },
    '6' => { :text => "НАЗНАЧИТЬ МАРШРУТ ПОЕЗДУ", :method => 'define_route_for_train' },
    '7' => { :text => "ДОБАВИТЬ ВАГОН К ПОЕЗДУ", :method => 'add_wagon_to_train' },
    '8' => { :text => "ОТЦЕПИТЬ ВАГОН ОТ ПОЕЗДА", :method => 'del_wagon_from_train' },
    '9' => { :text => "ПЕРЕМЕСТИТЬ ПОЕЗД ПО МАРШРУТУ", :method => 'move_train' },
    '10' => { :text => "ПОСМОТРЕТЬ СПИСОК СТАНЦИЙ", :method => 'show_list_of_stations' },
    '11' => { :text => "ПОСМОТРЕТЬ СПИСОК ПОЕЗДОВ НА СТАНЦИИ", :method => 'show_list_of_trains' }

  }

  def action_item(klass, action, arguments = [])
    klass.send(action, *arguments)
  end


  def create_station
    print "ВВЕДИТЕ НАЗВАНИЕ СТАНЦИИ: "
    name = gets.chomp
    stations << Station.new(name)
    puts "СТАНЦИЯ '#{name}' СОЗДАНА"
    continue_story
  end

  def create_cargo_train
    print "ВВЕДИТЕ НОМЕР ГРУЗОВОГО ПОЕЗДА: "
    number = gets.chomp
    trains_cargo << TrainCargo.new(number)
    puts "ПОЕЗД '#{number}' СОЗДАН"
    continue_story
  end

  def create_passenger_train
    print "ВВЕДИТЕ НОМЕР ПАССАЖИРСКОГО ПОЕЗДА: "
    number = gets.chomp
    trains_cargo << TrainPassenger.new(number)
    puts "ПОЕЗД '#{number}' СОЗДАН"
    continue_story
  end

  def create_route
    if stations.any? && stations.size > 1
      puts "ВЫБЕРИТЕ НАЧАЛЬНУЮ СТАНЦИЮ: "
      stations.each_with_index { |s, i| puts "#{i+1} - Станция #{s.name}" }
      index = gets.chomp.to_i - 1
      start_station = stations[index]
      puts "ВЫБЕРИТЕ КОНЕЧНУЮ СТАНЦИЮ: "
      stations_dup = stations.dup
      stations_dup.delete(start_station)
      stations_dup.each_with_index { |s, i| puts "#{i+1} - Станция #{s.name}" }
      index = gets.chomp.to_i - 1
      end_station = stations_dup[index]
      routes << Route.new(start_station, end_station)
      puts "СОЗДАН МАРШРУТ - ИЗ #{start_station} В #{end_station}"
    elsif stations == 1
      puts "ERROR - Нельзя создать маршрут из одной станции. Создайте еще"
    else
      puts "ERROR - Вы не создали не одной станции"
    end
    continue_story
  end

  def add_station_to_route
    if routes.any?
      puts "ВЫБЕРИТЕ МАРШРУТ"
      routes.each_with_index { |r , i| puts "#{i+1} - Маршрут из #{r.first.name} в #{r.last.name}" }
      index = gets.chomp.to_i - 1
      selected_route = routes[index]
      stations_dup = stations.dup
      stations_dup = stations_dup.delete_if { |st| selected_route.show_route.include?(st) }
      if stations.any?
      puts "ВЫБЕРИТЕ СТАНЦИЮ ДЛЯ ДОБАВЛЕНИЯ В МАРШРУТ"
      stations_dup.each_with_index { |s, i| puts "#{i+1} - Станция #{s.name}" }
      index = gets.chomp.to_i - 1
      selected_route.add_mid_station(stations_dup[index])
      else
        puts "ERROR - Нету станция для добавления. Добавьте еще"
      end
    else
      puts "ERROR - Нету маршцрутов для редактирования."
    end
    continue_story
  end

  def define_route_for_train
    if trains.any?
      puts "ВЫБЕРИТЕ ПОЕЗД"
      trains.each_with_index { |t , i| puts "#{i+1} - Поезд  #{t.number}" }
      index = gets.chomp.to_i - 1
      selected_train = trains[index]
      if routes.any?
      puts "ВЫБЕРИТЕ МАРШРУТ"
      routes.each_with_index { |r , i| puts "#{i+1} - Маршрут из #{r.first.name} в #{r.last.name}" }
      index = gets.chomp.to_i - 1
      selected_route = routes[index]
      selected_train.set_route(selected_route)
      puts "МАРШРУТ ДОБАВЛЕН"
      else
       puts "НЕТУ МАРШРУТОВ"
      end
    else
     puts "ERROR - НЕТУ ПОЕЗДОВ ДЛЯ РЕДАКТИРОВАНИЯ."
    end
    continue_story
  end



  def show_list_of_stations
   puts "СПИСОК СТАНЦИЙ"
   stations.each_with_index { |s, i| puts "#{i+1} - Станция #{s.name}" }
   continue_story
  end

  def show_list_of_trains
    puts "ВЫБЕРИТЕ СТАНЦИЮ"
    stations.each_with_index { |s, i| puts "#{i+1} - Станция #{s.name}" }
    index = gets.chomp.to_i - 1
    selected_station = stations[index]
    puts "СПИСОК ПОЕЗДОВ НА СТАНЦИИ: "
    selected_station.trains.each_with_index { |t, i| puts "#{i}. - ПОЕЗД #{t.number}"}
    continue_story
  end

  def add_wagon_to_train
    selected_train = select_train
    type = selected_train.type
      case type
        when :cargo
          selected_train.add_wagon(WagonCargo.new)
        when :passenger
          selected_train.add_wagon(WagonPassenger.new)
      end
    puts "ВАГОН ДОБАВЛЕН"
    continue_story
  end

  def del_wagon_from_train
    selected_train = select_train
    selected_train.del_wagon
    puts "ВАГОН УДАЛЕН"
    continue_story
  end



  def move_train
    selected_train = select_train
    puts "ВЫБЕРИТЕ КУДА ПОЕДЕТ ПОЕЗД"
    puts "1. ВПЕРЕД"
    puts "2. НАЗАД"
    action = gets.chomp
    case action
      when "1"
        selected_train.move_next
      when "2"
        selected_train.move_prev
    end
    puts "ПОЕЗД НА СТАНЦИИ #{selected_train.current_station.name}"
    continue_story
  end

  def select_train
    puts "ВЫБЕРИТЕ ПОЕЗД"
    trains.each_with_index { |t , i| puts "#{i+1} - Поезд  #{t.number}" }
    index = gets.chomp.to_i - 1
    selected_train = trains[index]
  end

  def trains
    trains_cargo + trains_passenger
  end

  def continue_story
    puts "_____________________________"
    print "press any key to continue..."
    STDIN.getch
    print ''
  end
end
