def enum_multiply(arr)
  arr.map{|num| num * 2}
end

class Array
  def my_each
    self.map{|x| yield(x)}
    self
  end
end


def median(arr)
  arr.sort!
  if arr.count % 2 == 0
    (arr[arr.length / 2] + arr[arr.length / 2 + 1]) / 2
  else
    arr[arr.count / 2 + 1]
  end
end


def inject_strings(arr)
  arr.inject(''){|x,y| x += y}
end