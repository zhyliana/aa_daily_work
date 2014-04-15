



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
#
board = [
    [0,0,0],
    [1,0,1],
    [0,0,0]
  ]
#

def empty?(board, row, column)
  if board[row][column] == 0
    true
  else
    false
  end
end

def place_mark(row, column, mark, board)
  board[row][column] = mark
end

place_mark(0,1,-1,board)

p board






