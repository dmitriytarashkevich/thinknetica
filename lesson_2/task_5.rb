=begin
  Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя). 
  Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным. 
  (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?) 
  Алгоритм опредления високосного года: docs.microsoft.com
=end

days_of_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

print "Год: "
year = gets.chomp.to_i
days_of_months[1] = 29 if year % 400 == 0 || (year % 4 == 0 && year % 100 != 100) 

print "Номер месяца: "
month = gets.chomp.to_i

day = 0
loop do
  print "День месяца: "
  day = gets.chomp.to_i
  break if day <= days_of_months[month-1]

  puts "Ошибка в месяце #{days_of_months[month-1]} дней"
end

result =  days_of_months.take(month-1).sum + day
puts result

