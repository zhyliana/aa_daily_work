def guesser
  guesses = []
  answer = rand(100)+1
  guess = 0

  until guess == answer
    puts "What is your guess?"
    guess = gets.chomp.to_i

    if guess > answer
      puts "too high"
    elsif guess < answer
      puts "too low"
    else
      puts "you win"
    end
  end

end

