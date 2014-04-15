# Tic-tac-toe AI

Let's extend my tic-tac-toe AI player so that is is unbeatable! **Use
[my TicTacToe solution][ttt-sol] please**.
[ttt-sol]: https://github.com/appacademy/solutions/blob/master/w1/w1d2/06_tic_tac_toe.rb

## Phase I: `TicTacToeNode`

Let's create a class `TicTacToeNode`. This will represent a TTT
game-state: it will store the current state of the `board` plus the
`next_player` to move. Also, if given, store the `prev_move_pos` (this
will come in handy later).

This doesn't use the `TreeNode` you made earlier. We are making a
completely new class independent of the `TreeNode`.

Write a method `children` that returns nodes representing all the
potential game states one move after the current node. To create
this method, it will be necessary to iterate through all positions
that are not `empty?` on the board object, make a mark
using `next_player`, and shovel into an array the resulting node.
Return this array. It is essential that you pass in the position
that you makred as `prev_move_pos` for reasons that will make sense
when we use it later.

Next, we want to characterize a node as either a
`#losing_node?(player)` or `#winning_node?(player)`. A `#losing_node?`
means:

* The board is over and the opponent has won, OR
* It is the player's turn, and all the children nodes are losing
  boards for the player, OR
* It is the opponent's turn, and one of the children nodes is a
  losing board for the player.

**NB: a draw (Board#tied?) is NOT a loss, if a node is a draw, losing_node? should return false**

Likewise, a winning node means either:

* The board is over and the player has won, OR
* It is the player's turn, and one of the children nodes is a winning
  board for the player, OR
* It is the opponent's turn, and all of the children nodes are
  winning nodes for the player.

Notice that `winning_node?` and `losing_node?` are defined
recursively. This indicates that while a node itsself might not
immediately result in victory, if anywhere down the line a victory
is inevitable a node is still a winner. 

## Phase II: `SuperComputerPlayer`

Write a subclass of `ComputerPlayer`; we'll override the `#move`
method to use our `TicTacToeNode`.

In the `#move` method, build a `TicTacToeNode` from the board stored
stored in the `game` passed in as an argument. Next, iterate through
the `children` of the node we just created. If any of the children
is a `winning_node?` for the mark passed in to the `#move` method,
`return` that node's `prev_move_pos` because that is the position
that causes a certain victory! I told you we would use that later!

If none of the `children` of the node we created are `winning_node?`s,
that's ok. We can just pick one that isn't a `losing_node?` and return
its `prev_move_pos`. That will prevent the opponent from ever winning,
and that's almost as good. To make that even more clear: if a winner 
isn't found, pick one of the children of our node that returns `false` 
to `losing_node?`.

Run your TTT game with the `SuperComputerPlayer` and weep tears of shame
because you can't beat a robot at tic tac toe.
