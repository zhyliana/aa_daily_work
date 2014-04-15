def merge_sort(arr)
  middle = arr.length/2
  left = []
  right = []
  if arr.length <= 1
    return arr
  else
    left = merge_sort(arr[0...middle])
    right = merge_sort(arr[middle..-1])
  end
  return merge(left,right)
end

def merge(left, right)
  result = []
  until left.empty? || right.empty?
    if  left.first <= right.first
      result << left.shift
    else
      result << right.shift
    end
  end
  result + left + right
end