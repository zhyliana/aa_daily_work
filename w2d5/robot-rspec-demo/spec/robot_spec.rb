require 'rspec'
require 'robot.rb'

# Assessments are for your benefit; they let us keep track of student
# progress, areas students need help in, etc. Especially if you are
# struggling, assessments help us know to figure that out.

# This assignment is intended to take ~1hr to complete. After an hour
# record how much you have finished by making a copy of your code at
# that point. Then take additional time to complete the assignment.
# Record how many hours this takes.

# Make sure to record both where you were after 1hr, and how long it
# takes to complete. It's really important for us to have accurate
# information where everyone is, so that we can pair people
# appropriately, know who to work closely with in the first couple
# weeks, etc.

# For the assignment, you'll need to know:
# * How to create a class
# * How to create instance variables
# * How to synthesize readers/accessors (`attr_reader`, `attr_accessor`)
# * How to write a method
# * How to use if/else
# * How to raise an exception
# * How to write your own `initialize` method
#   * How to use `super` to call a parent class' `initialize` method
# * How to use inheritance to extend a class

describe Robot do
  subject(:robot) { Robot.new }

  describe "#position" do
    its(:position) { should eq ([0, 0]) }
  end

  describe "move methods" do
    it "moves left" do
      robot.move_left
      robot.position.should eq([-1, 0])
    end

    it "moves right" do
      robot.move_right
      robot.position.should eq([1, 0])
    end

    it "moves up" do
      robot.move_up
      robot.position.should eq([0, 1])
    end

    it "moves down" do
      robot.move_down
      robot.position.should eq([0, -1])
    end
  end
end

describe Item do
  subject(:item) do
    Item.new("rubies", 20)
  end

  its(:name) { should eq("rubies") }
  its(:weight) { should eq(20) }
end

describe Robot do
  subject(:robot) { Robot.new }
  let(:item1) { double("item", :weight => 10) }
  let(:item2) { double("item2", :weight => 30) }

  let(:light_item) { double("heavy_item", :weight => 1) }
  let(:max_weight_item) { double("max_weight_item", :weight => 250) }

  describe "#items" do
    its(:items) { should eq([]) }
  end

  describe "#pick_up" do
    it "adds item to items" do
      robot.pick_up(item1)
      robot.items.should include(item1)
    end
  end

  describe "#items_weight" do
    its(:items_weight) { should eq(0) }

    it "should sum items weights" do
      robot.pick_up(item1)
      robot.pick_up(item2)

      robot.items_weight.should eq(40)
    end
  end

  describe "#pick_up" do
    it "should not add item past maximum weight of 250" do
      robot.pick_up(max_weight_item)

      expect do
        robot.pick_up(light_item)
      end.to raise_error(ArgumentError)
    end
  end
end

describe Robot do
  subject(:robot) { Robot.new }

  describe "#health" do
    its(:health) { should eq(100) }
  end

  describe "#wound" do
    it "decreases health" do
      robot.wound(20)
      robot.health.should eq(80)
    end

    it "doesn't decrease health below 0" do
      robot.wound(150)
      robot.health.should eq(0)
    end
  end

  describe "#heal" do
    it "increases health" do
      robot.wound(40)
      robot.heal(20)
      robot.health.should eq(80)
    end

    it "doesn't increase health over 100" do
      robot.heal(10)
      robot.health.should eq(100)
    end
  end

  describe "#attack" do
    it "wounds other robot with weak default attack" do
      robot2 = double("robot2")
      robot2.should_receive(:wound).with(5)

      robot.attack(robot2)
    end
  end
end

describe Bolts do
  subject(:bolts) { Bolts.new }

  it { should be_an(Item) }

  its(:name) { should eq("bolts") }
  its(:weight) { should eq(25) }

  describe "#feed" do
    it "heals the robots health 25pts" do
      robot = double("robot")
      robot.should_receive(:heal).with(25)

      bolts.feed(robot)
    end
  end
end

describe Weapon do
  subject(:weapon) { Weapon.new("power_shock", 10, 45) }

  it { should be_an(Item) }

  its(:name) { should eq("power_shock") }
  its(:weight) { should eq(10) }
  its(:damage) { should eq(45) }

  describe "#hit" do
    let(:robot) { double("robot") }

    it "hurts robot" do
      robot.should_receive(:wound).with(45)
      weapon.hit(robot)
    end
  end
end

describe Laser do
  subject(:laser) { Laser.new }

  it { should be_an(Weapon) }

  its(:name) { should eq("laser") }
  its(:weight) { should eq(125) }
  its(:damage) { should eq(25) }
end

describe PlasmaCannon do
  subject(:plasma_cannon) { PlasmaCannon.new }

  it { should be_an(Weapon) }

  its(:name) { should eq("plasma_cannon") }
  its(:weight) { should eq(200) }
  its(:damage) { should eq(55) }
end

describe Robot do
  subject(:robot) { Robot.new }

  describe "#equipped_weapon" do
    its(:equipped_weapon) { should eq(nil) }

    it "sets equipped weapon" do
      weapon = double("weapon")

      robot.equipped_weapon = weapon
      robot.equipped_weapon.should eq(weapon)
    end
  end

  describe "#attack" do
    let(:robot2) { double("robot2") }
    let(:weapon) { double("weapon") }

    it "uses the equipped weapon in attack" do
      robot.equipped_weapon = weapon

      weapon.should_receive(:hit).with(robot2)
      robot.attack(robot2)
    end
  end
end
