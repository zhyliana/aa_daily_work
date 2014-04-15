require 'hand.rb'
require 'deck.rb'

describe Hand do
  describe "Basics" do
    let(:hand) { Hand.new(Deck.new) }

    it "gives exactly 5 cards to each player" do
      expect(hand.cards.count).to eq(5)
    end

    it "Removes exactly 5 cards from the deck" do
      deck = Deck.new
      hand = Hand.new(deck)
      expect(deck.cards.count).to eq(52-5)
    end

    it "Responds to #discards" do
      hand.should respond_to(:discards)
    end

    it "allows a player to discard up to three cards" do
      remove_cards = hand.cards.shuffle[0...3]
      still_in_hand = hand.cards - remove_cards
      hand.discards(remove_cards)
      expect(hand.cards).to eq(still_in_hand)
    end

    it "does not allow a player to discard 4 cards" do
      remove_cards = hand.cards.shuffle[0..3]
      still_in_hand = hand.cards - remove_cards

      expect do
        hand.discards(remove_cards)
      end.to raise_error("Cannot discard more than 3 cards.")
    end

    it "Refills only until 5 cards are in hand" do
      remove_cards = hand.cards.shuffle[0...3]
      hand.discards(remove_cards)
      hand.refill_hand
      expect(hand.cards.count).to eq(5)
    end
  end

  describe "Hand logic" do

    it "Determines a Straight Flush" do
      deck = Deck.new([
        Card.new(:clubs, :four),
        Card.new(:clubs, :five),
        Card.new(:clubs, :six) ,
        Card.new(:clubs, :seven),
        Card.new(:clubs, :eight)
        ])
        hand = Hand.new(deck)

        expect(hand.hand_value).to eq([0,8])
      end


      it "Determines a Four of a Kind" do
        deck = Deck.new([
          Card.new(:clubs, :four),
          Card.new(:clubs, :four),
          Card.new(:clubs, :four) ,
          Card.new(:clubs, :four),
          Card.new(:clubs, :eight)
          ])
          hand = Hand.new(deck)

          expect(hand.hand_value).to eq([1,4])
        end

        it "Determines a Full House" do
          deck = Deck.new([
            Card.new(:clubs, :four),
            Card.new(:clubs, :four),
            Card.new(:clubs, :four) ,
            Card.new(:clubs, :eight),
            Card.new(:clubs, :eight)
            ])
            hand = Hand.new(deck)

            expect(hand.hand_value).to eq([2,4])
          end

          it "Determines a Flush" do
            deck = Deck.new([
              Card.new(:clubs, :four),
              Card.new(:clubs, :deuce),
              Card.new(:clubs, :jack) ,
              Card.new(:clubs, :eight),
              Card.new(:clubs, :nine)
              ])
              hand = Hand.new(deck)

              expect(hand.hand_value).to eq([3,11])
            end

            it "Determines a Straight" do
              deck = Deck.new([
                Card.new(:clubs, :four),
                Card.new(:hearts, :five),
                Card.new(:clubs, :six) ,
                Card.new(:clubs, :seven),
                Card.new(:clubs, :eight)
                ])
                hand = Hand.new(deck)

                expect(hand.hand_value).to eq([4,8])
              end

              it "Determines a Three of a Kind" do
                deck = Deck.new([
                  Card.new(:clubs, :four),
                  Card.new(:hearts, :four),
                  Card.new(:clubs, :four) ,
                  Card.new(:clubs, :seven),
                  Card.new(:clubs, :eight)
                  ])
                  hand = Hand.new(deck)

                  expect(hand.hand_value).to eq([5,4])
                end

                it "Determines a Two of a Kind" do
                  deck = Deck.new([
                    Card.new(:clubs, :four),
                    Card.new(:hearts, :four),
                    Card.new(:clubs, :seven) ,
                    Card.new(:clubs, :seven),
                    Card.new(:clubs, :eight)
                    ])
                    hand = Hand.new(deck)

                    expect(hand.hand_value).to eq([6,7])
                  end

                  it "Determines a One Pair" do
                    deck = Deck.new([
                      Card.new(:clubs, :four),
                      Card.new(:hearts, :four),
                      Card.new(:clubs, :five) ,
                      Card.new(:clubs, :seven),
                      Card.new(:clubs, :eight)
                      ])
                      hand = Hand.new(deck)

                      expect(hand.hand_value).to eq([7,4])
                    end

                    it "Determines a One Pair" do
                      deck = Deck.new([
                        Card.new(:clubs, :four),
                        Card.new(:hearts, :deuce),
                        Card.new(:diamonds, :five) ,
                        Card.new(:spades, :seven),
                        Card.new(:clubs, :eight)
                        ])
                        hand = Hand.new(deck)

                        expect(hand.hand_value).to eq([8,8])
                      end

                  end
                end