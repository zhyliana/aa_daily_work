def stock_picker(arr)
  max_profit = 0
  best_days = []
  arr.each_with_index do |price, i|
    arr.each_with_index do | price2, j|
      if  price2 - price > max_profit && i < j
        max_profit = price2 - price
        best_days = [i, j]
      end
    end
  end
  best_days

end

p stock_picker([7, 2, 9, 13, 21])