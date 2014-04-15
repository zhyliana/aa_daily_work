class Board
  attr_reader :dictionary, :player
  attr_accessor :playing_field

  def initialize
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @answer = @dictionary.sample.split(//)
    @playing_field = ["_"]*(@answer.length)
    @player = Player.new
  end

  def letter_found?(guess)
    @answer.include? @player.guess
  end

  def fill_in_letter(index)
    @playing_field[index] = guess
  end

  def positions(guess)
    correct_indices = []
    @answer.each_with_index do |letter,index|
      if letter == guess
        fill_in_letter(guess)
      end
    end
  end

end

class Game
  attr_accessor :board
  def initialize
    @board = Board.new
  end

  def turn
    puts @board.playing_field.join('')
    @board.player.guess
  end
end

class Player
  attr_accessor :chosen_letters
  def initialize
    @lives = 10
    @chosen_letters = []
  end

  def guess
    loop do
      puts "Guess a letter"
      guess = gets.downcase.chomp
      puts self.board.playing_field.join('')
      break if @chosen_letters.include?(guess) == false
    end
    @chosen_letters << guess
  end

end

hangman = Game.new
hangman.turn


