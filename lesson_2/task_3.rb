# Заполнить массив числами фибоначчи до 100

numbers = [0, 1]
loop do
  next_num = numbers.last(2).sum
  break if next_num > 100

  numbers << next_num
end

p numbers
