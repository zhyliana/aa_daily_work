class Hand
  attr_accessor :cards, :deck

  def initialize(deck)
    self.cards = deck.take(5)
    self.deck = deck
  end

  def reveal
    self.cards
  end

  def discards(cards_array)
    if cards_array.count < 4
      self.cards -= cards_array
    else
      raise "Cannot discard more than 3 cards."
    end
  end

  def refill_hand
    take_amount = 5 - self.cards.count
    self.cards += self.deck.take(take_amount)
  end

  def hand_value
    value = nil
    return royal_flush unless royal_flush.nil?
    return four_of_a_kind unless four_of_a_kind.nil?
    return full_house unless full_house.nil?
    return flush unless flush.nil?
    return straight unless straight.nil?
    return three_of_a_kind unless three_of_a_kind.nil?
    return two_pair unless two_pair.nil?
    return one_pair unless one_pair.nil?
    return high_card
  end

  def royal_flush
    if self.cards.map {|card| card.suit }.uniq.count == 1 # All the same suit
      card_values = self.cards.map {|card| card.value_points }
      if card_values.max - card_values.min == 4
        return [0,card_values.max] if card_values.uniq.count == 5
      end
    end
    nil
  end

  def four_of_a_kind
    card_values = self.cards.map {|card| card.value_points }
    card_values.uniq.each do |value|
      return [1, value]if card_values.count(value) == 4
    end
    nil
  end

  def full_house
    card_values = self.cards.map {|card| card.value_points }
    if card_values.uniq.count == 2
      card_values.uniq.each do | value |
        return [2, value] if card_values.count(value) == 3
      end
    end

    nil
  end

  def flush
    if self.cards.map {|card| card.suit }.uniq.count == 1
      max_value = self.cards.map {|card| card.value_points }.max
      return [3, max_value]
    end

    nil
  end

  def straight
    card_values = self.cards.map {|card| card.value_points }
    if card_values.max - card_values.min == 4
      return [4,card_values.max] if card_values.uniq.count == 5
    end

    nil
  end

  def three_of_a_kind
    card_values = self.cards.map {|card| card.value_points }
    if card_values.uniq.count == 3
      card_values.uniq.each do | value |
        return [5, value] if card_values.count(value) == 3
      end
    end

    nil
  end

  def two_pair
    card_values = self.cards.map {|card| card.value_points }
    if card_values.uniq.count == 3
      two_pairs = card_values.uniq.select do |value|
        card_values.count(value) == 2
      end
      return [6, two_pairs.max] if two_pairs.count == 2
    end

    nil
  end

  def one_pair
    card_values = self.cards.map {|card| card.value_points }
    if card_values.uniq.count == 4
      card_values.uniq.each do | value |
        return [7, value] if card_values.count(value) == 2
      end
    end

    nil
  end

  def high_card
    [8,self.cards.map {|card| card.value_points }.max]
  end

end