# Mastermind

Estimated time: 1hr.

In this project, you'll implement the game
[Mastermind][wiki-mastermind].

* There are six different peg colors:
    * Red
    * Green
    * Blue
    * Yellow
    * Orange
    * Purple
* The computer will select a random code of four pegs.
* The user gets ten turns to guess the code.
    * You decide how the user inputs his guess.
    * Maybe like so "RGBY" for red-green-blue-yellow.
* The computer should tell the player how many exact matches (right
  color in right spot) and near matches (right color, wrong spot) he
  or she has.
* Game ends when user guesses the code, or out of turns.
* Call your TA over and have them review your classes and
  general implementation before moving on.

## Suggestions

* You might want a `Code` class. You might want a `Code::parse` class
  method to parse user input. You might want a `Code::random` method
  to generate a random code sequence.
* You might want a `Game` class. This could keep track of the number
  of turns and have methods for reading user input and printing
  output.

[wiki-mastermind]: http://en.wikipedia.org/wiki/Mastermind_(game)
