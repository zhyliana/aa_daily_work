def dups(arr)
  unique = []
  arr.map do|x|
    unique << x unless unique.include? x
  end
  unique
end

p dups([1, 2, 1, 3, 3])
