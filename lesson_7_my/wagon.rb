# frozen_string_literal: true

require_relative 'factory'
require_relative 'validatable'

# Train wagon with known capacity, can transportate something
class Wagon
  include Factory
  include Validatable

  attr_reader :type, :capacity, :occupied_place

  def initialize(type, capacity)
    @type = type
    @capacity = capacity
    @occupied_place = 0
  end

  def validation_errors
    errors = []
    errors << 'Enter positive number as capacity' unless @capacity.positive?
    errors << 'Specify wagon type' unless @type
    errors
  end

  def free_place
    capacity - occupied_place
  end

  def place_available?
    free_place.positive?
  end

  def fill_place(capacity)
    if free_place >= capacity
      @occupied_place += capacity
    else
      puts "Error - Not enough free space (#{free_place}) in wagon for your #{@type} (#{capacity})"
    end
  end

  def to_s
    "#{@type} wagon, occupied space: #{@occupied_place}/#{@capacity}"
  end
end
