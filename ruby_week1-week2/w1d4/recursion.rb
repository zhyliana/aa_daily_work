def range(start, stop)
  array = []
  unless start > stop
    array << start
    array << range(start+1, stop)
  end
  array.flatten
end

def sum(arr)
  if arr.length == 2
    arr[0] + arr[1]
  else
    arr.shift + sum(arr)
  end

end

def exp1(b, n)
  if n == 0
    1
  else
    b * exp1(b, n-1)
  end
end

def exp2(b, n)
  if n == 0
    1
  elsif n.even?
    exp2(b, n/2) ** 2
  else
    b * (exp2(b, (n-1)/2) ** 2)
  end
end

