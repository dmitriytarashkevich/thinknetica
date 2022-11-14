require_relative 'wagon_passenger'

class TrainPassenger < Train
  WAGON_TYPE_CLASS = WagonPassenger

  def initialize(number)
    super(number, :passenger)
  end

end
