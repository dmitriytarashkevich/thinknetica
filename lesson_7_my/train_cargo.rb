# frozen_string_literal: true

require_relative 'wagon_cargo'

# Cargo train
class TrainCargo < Train
  WAGON_TYPE_CLASS = WagonCargo

  def initialize(number)
    super(number, :cargo)
  end
end
