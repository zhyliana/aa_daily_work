require 'deck.rb'

describe Deck do
  describe "::all_cards" do
    let(:all_cards) { Deck.all_cards }

    it "does not have duplicates" do
      expect(all_cards.uniq).to eq(all_cards)
    end

    it "loads itself with 52 cards" do
      expect(all_cards.count).to eq(52)
    end
  end

  describe "#initialize method" do

    it "can be initaited with a different set of cards than the default" do
      new_cards = [Card.new(:heart, :ace), Card.new(:club, :ace)]
      custom_deck = Deck.new(new_cards)
      expect(custom_deck.cards).to eq(new_cards)
    end

  end
end