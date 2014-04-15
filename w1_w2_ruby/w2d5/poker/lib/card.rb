# -*- coding: utf-8 -*-
class Card
  attr_accessor :suit, :value

  SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }

  VALUE_STRINGS = {
    :deuce => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 11,
    :queen => 12,
    :king  => 13,
    :ace   => 14
  }

  def initialize(suit, value)
    self.suit = suit
    self.value = value
  end

  def value_points
    VALUE_STRINGS[self.value]
  end

  def to_s
     VALUE_STRINGS[value].to_s + SUIT_STRINGS[suit]
  end

end