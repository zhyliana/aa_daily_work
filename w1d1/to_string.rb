def num_to_string(num, base)
  results = ""
  power = 1
  LETTERS =* ("A".."G")

  begin
    digit = (num/power % base)
    if digit > 9
      results << LETTERS[digit-10]
    else
      results << digit.to_s
    end
    power *= base
  end while power < num
  results.reverse
end

p num_to_string(234, 16)