# n = 251
#
# until n%7 == 0
#   n+=1
#   p n
# end

def factors(num)
  (1..num).select do |factor|
    num % factor == 0
  end
end

def bubble_sort(mixed)
  sorted = false
  (0...mixed.length).each do |i|
    return mixed if sorted
    sorted = true
    (i + 1...mixed.length).each do |j|
      if mixed[i] > mixed[j]
        sorted = false
        mixed[i], mixed[j] = mixed[j], mixed[i]
      end
    end
  end

  mixed
end

p bubble_sort([1,2,3,4,5,6,5])





