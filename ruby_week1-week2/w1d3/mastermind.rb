class Player
  attr_accessor :guess

  def initialize
    @guess = guess
  end

  def correct_length?(guess)
    if self.guess.count != 4
      puts "ERROR: Please choose exactly 4 colors"
      return false
     end
     true
  end

  # def correct_colors?(guess)
  #   color_options = ["R", "G", "B", "Y", "O", "P"]
  #   guess.each do |color|
  #     if color_options.include?(color)
  #       true
  #     else
  #       puts "ERROR: Color option not found"
  #     end
  #   end
  # end

  def turn
    puts "Your color options are:"
    puts "Red, Green, Blue, Yellow, Orange, Purple"
    puts "Choose your four colors in order."
    loop do
      puts "Input your answer as \"RYOB\"."
      @guess = gets.chomp.upcase.split(//)
      break if correct_length?(guess)
    end
  end
end




class Board
  attr_accessor :player
  attr_reader :code

  def initialize
    @code = ["R", "G", "B", "Y", "O", "P"].sample(4)
    @player = Player.new
  end

  def won?(guess)
    guess == @code
  end

  def feedback(guess)
    p self.code
    correct_color_pos_count = 0
    correct_color_count = 0

    guess.each_with_index do |color, position|
      correct_color_count += 1 if self.code.include?(color)
      correct_color_pos_count += 1 if self.code[position] == color
    end

     [correct_color_count-correct_color_pos_count, correct_color_pos_count]
  end

  def feedback_in_words(feedback_array)
    puts "There are #{feedback_array[1]} correct colors in the right position."
    puts "There are #{feedback_array[0]} correct colors but in the wrong position."
  end
end


class Game
  def initialize
    @board = Board.new
  end

  def start_game
    winner = false
    10.times do
      @board.player.turn
      player_guess = @board.player.guess
      if @board.won?(player_guess)
        puts "You won!"
        winner = true
        break
      else
        raw_feedback = @board.feedback(player_guess)
        user_friendly_feedback = @board.feedback_in_words(raw_feedback)
      end
    end

    unless winner
      puts "No more guesses left."
      puts "You lose :("
    end

  end



end

mastermind = Game.new
mastermind.start_game