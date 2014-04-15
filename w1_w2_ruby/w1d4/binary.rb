def bsearch(array, target)
  middle_position = array.length/2

  pivot = array[middle_position]

  if target == pivot
    middle_position
  elsif target < pivot
    bsearch(array.take(middle_position), target)
  else
    bsearch(array.drop(middle_position + 1), target) + middle_position + 1
  end
end


arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

p bsearch(arr, 5)