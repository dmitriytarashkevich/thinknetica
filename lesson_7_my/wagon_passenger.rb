# frozen_string_literal: true

# Wagon for passenger train
class WagonPassenger < Wagon
  def initialize(capacity)
    super(:passenger, capacity)
  end

  def fill_place
    super(1)
  end
end
