def rps(user_choice)
  wins = {
    "paper" => "rock",
    "rock" => "scissors",
    "scissors" => "paper",
  }

  computer_choice = wins.keys.sample
  puts computer_choice

  if user_choice == computer_choice
    "draw"
  elsif wins[user_choice] == computer_choice
    "you win"
  else
    "you lose"
  end
end

rps("rock")
