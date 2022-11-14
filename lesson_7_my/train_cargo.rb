require_relative 'wagon_cargo'

class TrainCargo < Train
  WAGON_TYPE_CLASS = WagonCargo

  def initialize(number)
    super(number, :cargo)
  end

end
