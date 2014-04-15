class Employee
  attr_accessor :bonus, :title, :salary
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end


  def bonus(multiplier)
    @bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss)
    super
    @employees = []
  end

  def bonus(multiplier)
    total_bonus = 0
    @employees.each do |employee|
      if employee.title == "Employee"
        total_bonus += employee.salary
      elsif employee.title == "Manager"
        total_bonus += employee.bonus(multiplier)
      end
    end
    total_bonus * multiplier
  end
end

sue = Manager.new("Sue", "Manager", 20, nil)
betty = Manager.new("Betty", "Manager", 15, sue)
bob = Employee.new("Bob", "Employee", 10, betty)
tom = Employee.new("Tom", "Employee", 10, betty)

betty.employees << bob
betty.employees << tom

sue.employees << betty

p betty.bonus(2)
p sue.bonus(2)