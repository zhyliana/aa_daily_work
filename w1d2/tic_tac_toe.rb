class Board

  attr_accessor :board
  attr_accessor :valid_moves

  def initialize
    create_board
  end

  def create_board
    @board = [
        [0,0,0],
        [0,0,0],
        [0,0,0]
      ]
  end

  def show_board
    @board.each do |row|
      p "#{row}"
      p "\n"
    end
  end

  def won?(board)
    return true if
      (board[0][0] + board[1][0] + board[2][0]).abs == 3 ||
      (board[0][1] + board[1][1] + board[2][1]).abs == 3||  #=> all verticals
      (board[0][2] + board[1][2] + board[2][2]).abs == 3||

      (board[0][0] + board[0][1] + board[0][2]).abs == 3||
      (board[1][0] + board[1][1] + board[1][2]).abs == 3|| #=> all horizontals
      (board[2][2] + board[2][1] + board[2][2]).abs == 3||

      (board[0][0] + board[1][1] + board[2][2]).abs == 3||
      (board[2][0] + board[1][1] + board[0][2]).abs == 3

  end


  def empty?(row, column)
    if board[row][column] == 0
      true
    else
      false
    end
  end

  def valid_moves
    valid = []
    @board.each_with_index do |row, r|
      row.each_with_index do |column, c|
        valid << [r,c] if empty?(r, c)
      end
    end
    valid
  end

  def place_mark(row, column, mark)
    @board[row][column] = mark
  end
end

class Game

  def initialize(player1, computer)
    @player1 = HumanPlayer.new
    @computer = ComputerPlayer.new
    @current_player = @player1
    @board = Board.new
  end

  def switch_players
    @current_player.class?(HumanPlayer) ? @current_player = @computer :
    @current_player = @player1
  end

  def play
    "Welcome to tic-tac-toe"

    until won?
      if @current_player.is_a?(HumanPlayer)
        "Next move move?(row,colum)"
        move = gets.chomp
        place_mark(move, @current_player.mark) if empty?(move)
      else
        temp_valid_array = valid_moves
        computer_move =

      end
  end
end

class HumanPlayer
  def mark
    @mark = 1
  end
end

class ComputerPlayer
  def mark
    @mark = -1
  end
end