require 'card.rb'

class Deck
  attr_accessor :cards

  def initialize(cards = nil)
    @cards = cards
  end

  def cards
    if @cards.nil?
      @cards = Deck.all_cards.shuffle!
    end

    @cards
  end

  def take(number)
    self.cards.shift(number)
  end

  def self.all_cards
    full_deck = []
    Card::SUIT_STRINGS.keys.each do |suit|
      Card::VALUE_STRINGS.keys.each do |value|
        full_deck << Card.new(suit, value)
      end
    end
    full_deck
  end

end