# frozen_string_literal: true

require_relative 'test_data_generation'
require_relative 'interactive_console_tools'
require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_passenger'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_passenger'

# Runnable class to start programm
class Main
  prepend TestDataGeneration
  include InteractiveConsoleTools
end

Main.new.show_menu
