def make_change(amount, coins)
  min_coins = amount
  best_array = []

  coins.select { |coin| coin <= amount }.each do |coin|
    if amount == coin
      best_array = [coin]
      break
    else
      possible_change = make_change(amount - coin, coins)
      possible_change << coin

      if possible_change.length < min_coins
        min_coins = possible_change.length
        best_array = possible_change
      end
    end
  end

  best_array
end

p make_change(51, [1,7,10])