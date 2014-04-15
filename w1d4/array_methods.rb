class Array
  def my_each (&prc)
    i = 0
    while i < self.length do
      prc.call(self[i])

      i += 1
    end
    self
  end

  # my_each
  def my_map(&prc)
    mapped_array = []
    self.my_each do |el|
      mapped_array << proc.call(el)
    end
    mapped_array
  end

  def my_select(&prc)
    select_arr = []
    self.my_each do |el|
      if prc.call(el)
        select_arr << el
      end
    end
    select_arr
  end

  def my_inject(accum, &prc)
    self.my_each do |el|
      accum = prc.call(accum, el)
    end
    accum
  end

  def my_sort(&prc)
    sorted = false
    until sorted
      sorted = true
      i = 0
      while i < self.length - 1
        if prc.call(self[i], self[i + 1]) == -1
          self[i], self[i + 1] = self[i + 1], self[i]
          sorted = false
        end
        i += 1
      end
    end
    self
  end

end



def eval_block (*args, &prc)
  if prc == nil
    puts "NO BLOCK GIVEN"
  else
    prc.call(*args)
  end
end

˜










