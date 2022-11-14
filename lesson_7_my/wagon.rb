require_relative 'factory'

class Wagon
  include Factory

  attr_reader :type

  def initialize(type)
    @type = type
  end

end
