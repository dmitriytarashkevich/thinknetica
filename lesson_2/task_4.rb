# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).


vowel = ['a', 'e', 'i', 'o', 'u']
vowel_hash = Hash.new

('a'..'z').each_with_index.map do |letter, i|
  if vowel.include?(letter)
    vowel_hash[letter] = i + 1
  end
end

p vowel_hash
