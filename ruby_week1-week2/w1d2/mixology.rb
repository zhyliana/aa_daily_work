def remix(drinks)
  alcohol = []
  mixer = []
  remixed_drinks = []

  drinks.each do |drink|
    alcohol << drink[0]
    mixer << drink[1]
  end

  alcohol.shuffle!
  mixer.shuffle!

  drinks.count.times do
    remixed_drinks << [alcohol.pop, mixer.pop]
  end

  remixed_drinks
end

def remix(drinks)
  drinks.map(&:first).zip(drinks.map(&:last).shuffle)
end


p remix([
  ["rum", "coke"],
  ["gin", "tonic"],
  ["scotch", "soda"]
])