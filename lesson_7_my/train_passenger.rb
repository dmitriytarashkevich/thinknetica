# frozen_string_literal: true

require_relative 'wagon_passenger'

# Passenger train
class TrainPassenger < Train
  WAGON_TYPE_CLASS = WagonPassenger

  def initialize(number)
    super(number, :passenger)
  end
end
