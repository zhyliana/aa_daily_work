require 'card.rb'

describe Card do
  let (:card) { Card.new(:hearts, :ace) }

  it "should respond to #value" do
    card.should respond_to(:value)
  end

  it "should respone to #suit" do
    card.should respond_to(:suit)
  end

  it "should have a value in between 2 and 14" do
    expect(card.value_points.between?(2,14)).to eq(true)
  end
end