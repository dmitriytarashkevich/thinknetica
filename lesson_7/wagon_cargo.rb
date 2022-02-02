class WagonCargo < Wagon

  def initialize(capacity)
    super(:cargo, capacity)
  end

  def take_capacity(volume)
    volume > free_capacity ? false : self.free_capacity -= volume
  end
end
