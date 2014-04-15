


def make_change(amount, priority = 25)
  array_change = []

  if amount < 5
    amount.times do
      array_change << 1
    end
  elsif amount > priority
    (amount/priority).times do
      array_change << priority
    end
    array_change << make_change(amount % priority)
  elsif amount > 25
    (amount/25).times do
      array_change << 25
    end
    array_change << make_change(amount%25)
  elsif amount > 10
    (amount / 10).times do
      array_change << 10
    end
    array_change << make_change(amount%10)
  else
    (amount / 5).times do
      array_change << 5
    end
    array_change << make_change(amount%10)
  end
  array_change.flatten

  array_change.each do |coin|
    b[coin] += 1
  end

end




#############################
def coin_type(amount, coin_value)
  (amount/coin_value).times do
    coin_value
  end
end

coins = [10, 7, 9]

coins.each do |value|
 coin_type(25, value)
end

