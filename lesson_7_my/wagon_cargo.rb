# frozen_string_literal: true

require_relative 'wagon'

# Freight wagon
class WagonCargo < Wagon
  def initialize(capacity)
    super(:cargo, capacity)
  end
end
