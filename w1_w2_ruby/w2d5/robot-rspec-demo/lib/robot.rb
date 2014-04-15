class Robot
  attr_reader :position
  attr_reader :items
  attr_reader :health
  attr_accessor :equipped_weapon

  def initialize
    @position = [0, 0]
    @items = []
    @health = 100
    @equipped_weapon = nil
  end

  def move_left
    move(-1, 0)
  end
  def move_right
    move(1, 0)
  end
  def move_up
    move(0, 1)
  end
  def move_down
    move(0, -1)
  end

  def pick_up(item)
    if items_weight + item.weight <= 250
      @items << item
    else
      raise ArgumentError.new
    end
  end

  def items_weight
    items.map(&:weight).inject(0, :+)
  end

  def wound(amt)
    @health = [@health - amt, 0].max
  end

  def heal(amt)
    @health = [@health + amt, 100].min
  end

  def attack(robot2)
    if self.equipped_weapon
      self.equipped_weapon.hit(robot2)
    else
      robot2.wound(5)
    end
  end

  private
  def move(dx, dy)
    old_x, old_y = position
    @position = [old_x + dx, old_y + dy]
  end
end

class Item
  attr_reader :name
  attr_reader :weight

  def initialize(name, weight)
    @name, @weight = name, weight
  end
end

class Bolts < Item
  def initialize
    super("bolts", 25)
  end

  def feed(robot)
    robot.heal(25)
  end
end

class Weapon < Item
  attr_reader :damage
  def initialize(name, weight, damage)
    super(name, weight)
    @damage = damage
  end

  def hit(robot)
    robot.wound(45)
  end
end

class Laser < Weapon
  def initialize
    super("laser", 125, 25)
  end
end

class PlasmaCannon < Weapon
  def initialize
    super("plasma_cannon", 200, 55)
  end
end
