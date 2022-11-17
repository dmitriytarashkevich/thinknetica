# frozen_string_literal: true

require 'io/console'
require_relative 'menu_actions'

# Tools for interacting with user through console
module InteractiveConsoleTools
  include MenuActions

  class NothingToSelectException < RuntimeError; end

  def show_menu
    system 'clear'
    loop do
      menu_action = select_using_console(menu_actions, 'menu item')
      return if menu_action == 'terminate_program'

      safely_perform(menu_action)
      continue_story
    end
  end

  private

  def safely_perform(menu_action)
    send(menu_action)
  rescue RuntimeError => e
    puts e.message
  end

  def menu_actions
    @menu_actions ||= MenuActions.instance_methods.sort.append('terminate_program')
  end

  def select_using_console(list_items, item_name = nil)
    if list_items.is_a?(Class)
      item_name ||= list_items.name.downcase
      list_items = list_items.instances
    end
    item_name ||= list_items[0].class.name.downcase
    raise NothingToSelectException, "No available #{item_name}. Create new and try again" unless list_items.any?

    select_using_console!(item_name, list_items)
  end

  def select_using_console!(item_name, list_items)
    puts "Select #{item_name}"
    show_list_of(list_items)
    list_items[prompt("#{item_name} number").to_i - 1]
  end

  def show_list_of(list)
    if list.any?
      list.each_with_index { |el, i| puts "#{i + 1} - #{el.to_s.gsub('_', ' ').capitalize}" }
    else
      puts 'No available items to show'
    end
  end

  def prompt(prompt_string)
    puts "Enter #{prompt_string}"
    loop do
      entered_string = gets.chomp
      return entered_string unless entered_string.empty?

      puts 'Common! say something!'
    end
  end

  def continue_story
    puts '_____________________________'
    puts 'press any key to continue...'
    puts '_____________________________'
    $stdin.getch
    system 'clear'
  end
end
