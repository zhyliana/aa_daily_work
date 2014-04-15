class Array
  def uniq
    [].tap do |uniq_array|
      self.each do |x|
        uniq_array << x unless uniq_array.include?(x)
      end
    end
  end

  def two_sum
    index_array = []
    0.upto(self.count - 1) do |start_ind|
      (start_ind + 1).upto(self.count - 1) do |stop_ind|
        if (self[start_ind] + self[stop_ind]) == 0
          index_array << [start_ind, stop_ind]
        end
      end
    end

    index_array
  end

  def my_transpose
    Array.new(3) { [] }.tap do |new_array|
      self.each do |row|
        row.each_with_index do |col, index|
          new_array[index] << col
        end
      end
    end
  end

  def best_days
    max_profit = 0
    best_days = []

    (0...(self.count-1)).each do |buy_day|
      ((buy_day + 1)..(self.count - 1)).each do |sell_day|
        if (self[sell_day] - self[buy_day]) > max_profit
          max_profit = self[sell_day] - self[buy_day]
          best_days = [buy_day, sell_day]
        end
      end
    end

    best_days
  end

end

class TowersofHanoi
  attr_accessor :stacks


  def initialize
    @stacks = [TowersofHanoi.discs, [], []]
  end

  def self.discs
    [3,2,1]
  end

  def move(start_stack, end_stack)
    if valid_move?(start_stack, end_stack)
      self.stacks[end_stack] << self.stacks[start_stack].pop
    end
  end

  def valid_move?(start_stack, end_stack)
    return true if self.stacks[end_stack].empty?

    new_end_stack = self.stacks[end_stack]
    new_start_stack = self.stacks[start_stack]

    return true if new_end_stack[-1] > new_start_stack[-1]
    return false
  end

  def won?
    self.stacks[2] == self.stacks[2].sort.reverse && self.stacks[0..1].all?(&:empty?)
  end
end






##
# h = TowersofHanoi.new
# p h.move(0,1)
# p h.stacks
# p t.valid_move?(0,1)
# p t.move(0,1)
# p t.stacks
# p t.move(1,0)
# p t.stacks