# frozen_string_literal: true

require_relative 'instances'
require_relative 'validatable'

# Railway station entity
class Station
  include Instances
  include Validatable

  attr_reader :trains, :name
  alias to_s name

  def initialize(name)
    @name = name
    @trains = []
  end

  def validation_errors
    errors = []
    errors << 'Only letters allowed in station name' unless @name =~ /^\p{L}+$/
    errors
  end

  def train_types
    Hash[trains.group_by(&:type).map { |type, t| [type.to_s, t.count] }]
  end

  def receive_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def each_train(&block)
    trains.each(&block)
  end
end
