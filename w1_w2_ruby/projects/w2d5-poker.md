# Poker

## Rules

Your job is to create a Poker game TDD.

One of the simpler forms of Poker is [five card draw][five-card-draw].

* Each player is dealt five cards.
* Players bet; each player may fold, see the current bet, or raise.
* In turn, each player can choose to discard up to three cards.
    * They are dealt new cards from the deck to replace their old cards.
* Players bet again.
* If any players do not fold, then players reveal their hands; [strongest
  hand][poker-hands] wins the pot.

[five-card-draw]: http://en.wikipedia.org/wiki/Five-card_draw
[poker-hands]: http://en.wikipedia.org/wiki/List_of_poker_hands

## Design

Classes you will want:

* Card
* Deck
* Hand
    * The logic of calculating pair, three-of-a-kind, two-pair, etc. goes
      here.
    * Logic of which hand beats which would go here.
* Player
    * Each player has a hand, plus a pot
    * Player has methods to ask the user:
        * Which cards they wish to discard
        * Whether they wish to fold, see, or raise.
* Game
    * Holds the deck
    * Keeps track of whose turn it is
    * Keeps track of the amount in the pot.

Make sure to request a code review from your TA once you have some of
your classes implemented.
