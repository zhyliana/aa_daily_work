# def fib(n)
#   if n < 2
#     n
#   else
#     (fib(n-1) + fib(n-2))
#   end
# end
#
# p fib(5)

def fib(n)
  fib_num = []
  (1..n).to_a.each do |num|
    fib_num << nth_fib(num)
  end
  fib_num
end



def nth_fib(n)
  if n < 3
    1
  else
    nth_fib(n-2) + nth_fib(n-1)
  end
end

p fib(6)