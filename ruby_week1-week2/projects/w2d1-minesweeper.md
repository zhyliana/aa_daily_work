# Minesweeper

Everyone remembers [Minesweeper][minesweeper-wiki], right? Let's build
it! **Read all these instructions first**.

Start by supporing a single grid size: 9x9; randomly seed it with
bombs. The user has two choices each turn:

### Reveal

First, they can choose a square to reveal. If it contains a bomb, game
over. Otherwise, it will be revealed. If none of its neighbors
contains a bomb, then all the adjacent neighbors are also revealed. If
any of the neighbors have no adjacent bombs, they too are revealed. Et
cetera.

The "fringe" of the revealed area are squares all adjacent to a bomb
(or corner). The fringe should be revealed, but should contain counts
of how many adjacent bombs are adjacent.

### Flag bomb

The user may also flag a square as containing a bomb. The goal of the
game is to flag all the bombs correctly and reveal all the bomb-free
squares; at this point the game ends.

If a bomb is flagged incorrectly, it is not eligible to be revealed,
even if it otherwise would be.

### User interaction

You decide how to display the current game state to the user. I
recommend `*` for unexplored squares, `_` for "interior" squares when
exploring, and a one-digit number for "fringe" squares. I'd put an `F`
for flagged spots.

You decide how the user inputs their choice. I recommend a coordinate
system. Perhaps they should prefix their choice with either "r" for
reveal or "f" for flag.

### Code Review

After you have your UI working, request a code review from your
TA. Take notes and refactor before moving on.

### Saving

OK, it's time to add save/load functionality. You should be able to
save/load your minesweeper game to/from a file.

As a bonus, you may also wish to track the time it takes for the user
to solve the game. Perhaps keeping track of the ten best times in a
leaderboard. You may want to keep separate lists for the different
sizes.

### Hints

I think you should have a `Tile` class; there's a lot of information
to track about a `Tile` (bombed? flagged? revealed?) and some helpful
methods you could write (`#reveal`, `#neighbors`,
`#neighbor_bomb_count`). I would also have a `Board` class.

You should separate logic pertaining to Game UI and turn-taking from
the `Tile`/`Board` classes.

If you use command line arguments and `ARGV` to specify the name of
the save file to load, you may be surprised to find that console input
is broken. [This ruby-forum.com post][argv-description] explains how
gets interacts with `ARGV`/`ARGF`.

[minesweeper-wiki]: http://en.wikipedia.org/wiki/Minesweeper_(Windows)
[argv-description]: https://www.ruby-forum.com/topic/185266#809660
