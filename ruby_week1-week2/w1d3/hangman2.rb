class Player
  attr_reader :blank_word, :secret_word

  def receive_secret_length(secret_word)
    secret_word.length
  end

end
###########################################################
class HumanPlayer < Player
  def pick_secret_word
    puts "What is your secret...word?"
    @secret_word = gets.chomp.split(//)

  end

  def guess
    puts "What is your guess?"
    @guess = gets.chomp
  end

  def handle_guess_response(current_guess)
    return
  end


end
###########################################################
class ComputerPlayer < Player
  def initialize
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
  end

  def pick_secret_word
     @secret_word = @dictionary.sample.split(//)
  end

  def guess(secret_word_length)
    filtered_dictionary = possible_answers(secret_word_length)
    p filtered_dictionary
    hot_soup = letter_soup(filtered_dictionary)
    most_freq_letter(hot_soup)
  end

  def letter_soup(dictionary)
    letter_soup = []
    dictionary.each do |word|
      word.split(//).each do |letter|
        letter_soup << letter
      end
    end
  end

  def most_freq_letter(letter_soup)
    freq = letter_soup.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    most_freq_letter = letter_soup.max_by { |v| freq[v] }
  end

  def handle_guess_response(current_guess, secret_word_length)
    possible_answers(secret_word_length)
    remove_impossible_answers(current_guess)
  end

  def possible_answers(secret_word_length)
    @dictionary.select! do |word|
      word.length == secret_word_length
    end
  end

  def remove_impossible_answers(current_guess)
    @dictionary.select! do |word|
      word.split(//).include?(current_guess)
    end
  end

end
###########################################################
class Hangman
  def initialize (guessing_player , choosing_player)
    @choosing_player = choosing_player
    @guessing_player = guessing_player
    @secret_word = []
    @blank_word = []
    @guesses_remaining = 10
  end

  def start_game
    @secret_word = @choosing_player.pick_secret_word
    @guessing_player.receive_secret_length(@secret_word)
    @blank_word = Array.new(@secret_word.length){"_"}
    execute_turn until won? || @guesses_remaining == 0
  end

  def print_board
    puts @blank_word.join(' ')
  end

  def execute_turn
    current_guess = @guessing_player.guess(@secret_word.length)
    @guessing_player.handle_guess_response(current_guess, @secret_word.length)
    fill_in_blank(current_guess)
    puts "Player guesses \'#{current_guess}\'"
    print_board
    puts "Lives remaining: #{@guesses_remaining.to_s}"
  end

  def fill_in_blank(guess)
    if @secret_word.include?(guess)
      @secret_word.map.with_index do |letter, position|
        if letter == guess
          @blank_word[position] = guess
        end
      end
    else
      @guesses_remaining -= 1
    end
  end

  def won?
    @secret_word == @blank_word
  end

end
choosing_player = HumanPlayer.new
guessing_player = ComputerPlayer.new
hangman = Hangman.new(guessing_player, choosing_player)
hangman.start_game
