def deep_dup(nested_array)
  blasted_array = []
  if nested_array.length == 1
    blasted_array << nested_array
  else
    nested_array.each do |el|
      blasted_array << deep_dup(el)
    end
  end
  blasted_array
end

arr = ["a", ["b"], ["c", ["d"]]]

new_arr = deep_dup(arr)
p new_arr

new_arr[1] << "not supposed to be here"

p new_arr
p arr

