def ceasar_cipher(str,shift)
  alphabet = ('a'..'z').to_a
  str.split('').map! do |char|
    if char == ' '
      ' '
    else
      alphabet[(shift + alphabet.index(char)) % 26]
    end
  end.join('')
end

p ceasar_cipher('aaa zzz', 3)


