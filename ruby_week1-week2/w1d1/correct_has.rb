def correct_hash(hash)
  ab =* ("a".."z")
  Hash[hash.map{|k,v| [((ab[ab.index(k.to_s) + 1]) % 26).to_sym, v]}]
end

p correct_hash({ :a => "banana", :b => "cabbage", :c => "dental_floss", :d => "eel_sushi" })