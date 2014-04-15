require './tic_tac_toe_solution'

class TicTacToeNode
  attr_accessor :board, :mark, :prev_move_pos

  def initialize(board, mark, prev_move_pos = nil)
    @board = board
    @mark = :o
    @prev_move_pos = prev_move_pos
  end

  def children(parent_board) # current state of board
    open_spots = []
    parent_board.rows.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if parent_board.empty_spot?([i,j])
          open_spots << [i,j]
        end
      end
    end
    child_boards = []
    prev_move_pos = []

    open_spots.each do |spot|
      board_template = parent_board.dup
      #create child node, []=(pos, mark)
      board_template[spot] = :x
      child_boards << TicTacToeNode.new(board_template, self.mark, spot) # need previous move
      prev_move_pos << spot
    end
    child_boards
  end

  def winning_node?(player)



    # (self.board.rows + self.board.cols + self.board.diagonals).each do |triple|
#       return true if triple == [player, player, player]
#     end
  end



end
new_board =Board.new

game = TicTacToeNode.new(new_board, :x)
x = game.children(new_board)
x.each {|y| p y.board}
#p game.winning_node?(:o)