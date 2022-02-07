require 'io/console'

require_relative 'route'
require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_passenger'
require_relative 'station'
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
    system 'clear'
    loop do
      puts '0 - ВЫХОД'
      MENU_STATION.each { |k, v| puts "#{k} - #{v[:text]}" }
      menu_key = gets.chomp
      return if menu_key == '0'

      send(MENU_STATION[menu_key][:method])
      system 'clear'
    end
  end

  private

  attr_reader :trains_cargo, :trains_passenger, :wagons_cargo, :wagons_passenger, :routes, :stations

  WAGON_DESCRIPTION = {
    cargo: 'ВАГОН ГРУЗОВОЙ, ОБЪЕМ - %d м3, СВОБОДНО - %d м3',
    passenger: 'ВАГОН ПАССАЖИРСКИЙ, КОЛ-ВО МЕСТ - %d шт, СВОБОДНО - %d шт'
  }

  MENU_STATION = {
    '1' => { text: 'СОЗДАТЬ СТАНЦИЮ', method: 'create_station' },
    '2' => { text: 'СОЗДАТЬ ГРУЗОВОЙ ПОЕЗД', method: 'create_cargo_train' },
    '3' => { text: 'СОЗДАТЬ ПАССАЖИРСКИЙ ПОЕЗД', method: 'create_passenger_train' },
    '4' => { text: 'СОЗДАТЬ МАРШРУТ', method: 'create_route' },
    '5' => { text: 'ДОБАВИТЬ СТАНЦИЮ В МАРШРУТ', method: 'add_station_to_route' },
    '6' => { text: 'НАЗНАЧИТЬ МАРШРУТ ПОЕЗДУ', method: 'define_route_for_train' },
    '7' => { text: 'ДОБАВИТЬ ВАГОН К ПОЕЗДУ', method: 'add_wagon_to_train' },
    '8' => { text: 'ОТЦЕПИТЬ ВАГОН ОТ ПОЕЗДА', method: 'del_wagon_from_train' },
    '9' => { text: 'ПЕРЕМЕСТИТЬ ПОЕЗД ПО МАРШРУТУ', method: 'move_train' },
    '10' => { text: 'ПОСМОТРЕТЬ СПИСОК СТАНЦИЙ', method: 'show_list_of_stations' },
    '11' => { text: 'ПОСМОТРЕТЬ СПИСОК ПОЕЗДОВ НА СТАНЦИИ', method: 'show_list_of_trains' },
    '12' => { text: 'ЗАНЯТЬ МЕСТО(ОБЪЕМ) В ВАГОНЕ', method: 'occupied_capacity' }
  }

  def action_item(klass, action, arguments = [])
    klass.send(action, *arguments)
  end

  def create_station
    print 'ВВЕДИТЕ НАЗВАНИЕ СТАНЦИИ: '
    name = gets.chomp
    stations << Station.new(name)
    puts "СТАНЦИЯ '#{name}' СОЗДАНА"
    continue_story
  rescue ValidationError => e
    puts e
    retry
  end

  def create_cargo_train
    print 'ВВЕДИТЕ НОМЕР ГРУЗОВОГО ПОЕЗДА: '
    number = gets.chomp
    trains_cargo << TrainCargo.new(number)
    puts "ПОЕЗД '#{number}' СОЗДАН"
    continue_story
  rescue ValidationError => e
    puts e
    retry
  end

  def create_passenger_train
    print 'ВВЕДИТЕ НОМЕР ПАССАЖИРСКОГО ПОЕЗДА: '
    number = gets.chomp
    trains_passenger << TrainPassenger.new(number)
    puts "ПОЕЗД '#{number}' СОЗДАН"
    continue_story
  rescue ValidationError => e
    puts e
    retry
  end

  def create_route
    if stations.any? && stations.size > 1
      puts 'ВЫБЕРИТЕ НАЧАЛЬНУЮ СТАНЦИЮ: '
      start_station = select_station(stations)
      puts 'ВЫБЕРИТЕ КОНЕЧНУЮ СТАНЦИЮ: '
      end_station = select_station(stations - [start_station])
      routes << Route.new(start_station, end_station)
      puts "СОЗДАН МАРШРУТ - ИЗ #{start_station} В #{end_station}"
    elsif stations == 1
      puts 'ERROR - Нельзя создать маршрут из одной станции. Создайте еще'
    else
      puts 'ERROR - Вы не создали не одной станции'
    end
    continue_story
  end

  def add_station_to_route
    if routes.any?
      puts 'ВЫБЕРИТЕ МАРШРУТ'
      routes.each_with_index { |r, i| puts "#{i + 1} - Маршрут из #{r.first.name} в #{r.last.name}" }
      index = gets.chomp.to_i - 1
      selected_route = routes[index]
      if stations.any?
        puts 'ВЫБЕРИТЕ СТАНЦИЮ ДЛЯ ДОБАВЛЕНИЯ В МАРШРУТ'
        selected_route.add_mid_station(select_station(stations - selected_route.show_route))
      else
        puts 'ERROR - Нету станция для добавления. Добавьте еще'
      end
    else
      puts 'ERROR - Нету маршцрутов для редактирования.'
    end
    continue_story
  end

  def select_station(list_stations)
    list_stations.each_with_index { |s, i| puts "#{i + 1} - Станция #{s.name}" }
    index = gets.chomp.to_i - 1
    list_stations[index]
  end

  def define_route_for_train
    if trains.any?
      selected_train = select_train
      if routes.any?
        puts 'ВЫБЕРИТЕ МАРШРУТ'
        routes.each_with_index { |r, i| puts "#{i + 1} - Маршрут из #{r.first.name} в #{r.last.name}" }
        index = gets.chomp.to_i - 1
        selected_train.set_route(routes[index])
        puts 'МАРШРУТ ДОБАВЛЕН'
      else
        puts 'НЕТУ МАРШРУТОВ'
      end
    else
      puts 'ERROR - НЕТУ ПОЕЗДОВ ДЛЯ РЕДАКТИРОВАНИЯ.'
    end
    continue_story
  end

  def show_list_of_stations
    puts 'СПИСОК СТАНЦИЙ'
    stations.each_with_index { |s, i| puts "#{i + 1} - Станция #{s.name}" }
    continue_story
  end

  def show_list_of_trains
    puts 'ВЫБЕРИТЕ СТАНЦИЮ'
    selected_station = selected_station(stations)
    puts 'СПИСОК ПОЕЗДОВ НА СТАНЦИИ: '
    selected_station.each_train do |t|
      puts "# ПОЕЗД #{t.number} #{t.type == :cargo ? 'ГРУЗОВОЙ' : 'ПАССАЖИРСКИЙ'} - #{t.wagons.size} ВАГОНА(ОВ)"
      t.each_wagon_with_index do |w, i|
        puts "\t#{i}. #{format(WAGON_DESCRIPTION[w.type], w.capacity, w.free_capacity)}"
      end
    end
    continue_story
  end

  def add_wagon_to_train
    selected_train = select_train
    type = selected_train.type
    selected_train.add_wagon(create_wagon(type))
    puts 'ВАГОН ДОБАВЛЕН'
    continue_story
  end

  def create_wagon(type)
    case type
    when :cargo
      print 'ВВЕДИТЕ ОБЪЕМ ВАГОНА (м3): '
      capacity = gets.chomp.to_i
      WagonCargo.new(capacity)
    when :passenger
      print 'ВВЕДИТЕ КОЛ-ВО СИДЕНИЙ: '
      capacity = gets.chomp.to_i
      WagonPassenger.new(capacity)
    end
  end

  def occupied_capacity
    selected_train = select_train
    if selected_train.wagons.empty?
      puts 'В ПОЕЗДЕ ВАГОНОВ НЕТ'
    else
      selected_train.wagons.each_with_index do |w, i|
        puts "#{i + 1} - #{format(WAGON_DESCRIPTION[w.type], w.capacity, w.free_capacity)}"
      end
      index = gets.chomp.to_i - 1
      type = selected_train.type
      case type
      when :cargo
        print 'ВВЕДИТЕ ОБЪЕМ КОТОРЫЙ ХОТИТЕ ЗАПОЛНИТЬ (м3): '
        capacity = gets.chomp.to_i
        selected_train.wagons[index].take_capacity(capacity)
        puts 'ЗАПОЛНЕНО'
      when :passenger
        selected_train.wagons[index].take_capacity
        puts '1 МЕСТО ЗАНЯТО'
      end
    end
  end

  def del_wagon_from_train
    selected_train = select_train
    selected_train.del_wagon
    puts 'ВАГОН УДАЛЕН'
    continue_story
  end

  def move_train
    selected_train = select_train
    puts 'ВЫБЕРИТЕ КУДА ПОЕДЕТ ПОЕЗД'
    puts '1. ВПЕРЕД'
    puts '2. НАЗАД'
    action = gets.chomp
    case action
    when '1'
      selected_train.move_next
    when '2'
      selected_train.move_prev
    end
    puts "ПОЕЗД НА СТАНЦИИ #{selected_train.current_station.name}"
    continue_story
  end

  def select_train
    puts 'ВЫБЕРИТЕ ПОЕЗД'
    trains.each_with_index { |t, i| puts "#{i + 1} - Поезд  #{t.number}" }
    index = gets.chomp.to_i - 1
    trains[index]
  end

  def trains
    trains_cargo + trains_passenger
  end

  def continue_story
    puts '_____________________________'
    print 'press any key to continue...'
    $stdin.getch
    print ''
  end
end
