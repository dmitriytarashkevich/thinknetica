=begin
  Класс Station (Станция):
  Имеет название, которое указывается при ее создании
  Может принимать поезда (по одному за раз)
  Может возвращать список всех поездов на станции, находящиеся в текущий момент
  Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

require_relative 'instance_counter'
require_relative 'exception/validation_error'
require_relative 'validate'

class Station
  include InstanceCounter
  include Validate

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations.push(self)
    register_instance
  end

  def train_types
    Hash[trains.group_by{|train| train.type}.map {|type, t| [type.to_s, t.count]}]
  end

  def receive_train(train)
    self.trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  protected
  
  def validate!
    errors = []     
    errors << 'Укажите название станции' if @name.nil? || @name.empty?
    errors << 'Название должно начинаться с буквы' if @name =~ /^\d/
    raise ValidationError.new errors.join("\n") unless errors.empty?
  end
end
