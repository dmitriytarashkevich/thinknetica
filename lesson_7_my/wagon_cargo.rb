require_relative 'wagon'

class WagonCargo < Wagon

  def initialize(capacity)
    super(:cargo, capacity)
  end

end
