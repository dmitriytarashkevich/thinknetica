module InteractiveConsoleTools

  class NothingToSelectException < RuntimeError; end

  def select_using_console(item_name = nil, list_items)
    item_name ||= list_items[0].class.name.downcase
    if list_items.any?
      puts "Select #{item_name}"
      show_list_of(list_items)
      index = gets.chomp.to_i - 1
      list_items[index]
    else
      raise NothingToSelectException.new "No available #{item_name}. Create new and try again"
    end
  end

  def show_list_of(list)
    list.each_with_index { |el, i| puts "#{i + 1} - #{el.to_s.gsub("_", " ").capitalize}" }
  end

  def prompt(prompt_string)
    puts "Enter " + prompt_string
    gets.chomp
  end

  def continue_story
    puts "_____________________________"
    puts "press any key to continue..."
    puts "_____________________________"
    STDIN.getch
    system "clear"
  end

end
