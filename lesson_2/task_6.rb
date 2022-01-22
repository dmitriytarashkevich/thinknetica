=begin
  Сумма покупок. 
  Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом). 
  Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара. 
  На основе введенных данных требуетеся:
  - Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш, 
    содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
  - Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end

cart = Hash.new

puts "Сумма покупок."
loop do
  print "Для выхода введите 'stop'\nНазвание товара: "
  title = gets.chomp
  break if title == 'stop'
  
  cart[title] = {}
  print 'Цена: '
  cart[title][:price] = gets.chomp.to_f.round(2)
  print 'Количество: '
  cart[title][:quantity] = gets.chomp.to_f.round(2)  
end

result = 0
title_max_length = cart.keys.map{|t| t.length}.max
puts "Название#{' '*(title_max_length - 8)}\tЦена\tКол-во\tСумма"
cart.each do |k,v|
  sum = (v[:price]*v[:quantity]).round(2)
  result+=sum
  puts "#{k}#{' '*(title_max_length - k.length)}\t#{v[:price]}\t#{v[:quantity]}\t#{sum}"
end
puts "Итого: #{result}"
