class Fixnum
  def hundred(str)
    if str[0] == 0 && str[1..-1].to_i < 19
      words_hash(str[1..-1].to_i)
    elsif str[0] == 0
      "#{words_hash[str[1].to_i * 10]} #{words_hash[str[2].to_i]}"
    else
      "#{words_hash[str[0].to_i]} hundred #{words_hash[str[1].to_i * 10]} #{words_hash[str[2].to_i}"
    end
  end

  def in_words
    result                  = ''
    words_hash              = {0=>"zero",1=>"one",2=>"two",3=>"three",4=>"four",5=>"five",6=>"six",7=>"seven",8=>"eight",9=>"nine",
      10  =>"ten",11=>"eleven",12=>"twelve",13=>"thirteen",14=>"fourteen",15=>"fifteen",16=>"sixteen",
      17 =>"seventeen", 18=>"eighteen",19=>"nineteen",
      20  =>"twenty",30=>"thirty",40=>"forty",50=>"fifty",60=>"sixty",70=>"seventy",80=>"eighty",90=>"ninety"}

      scale                   = {4=>"thousand", 7=>" million",  10 => "billion", 13=>"trillion"}

      num_string              = self.to_s

      until num_string.length%3 == 0
        num_string            = "0#{num_string}"
      end

      num_string.scan(/.{3}/).each do |triplet|
        result += "#{hundred(triplet)} #{scale[self.to_s.length]}"
      end
      result
    end
  end
end


p 124156178.in_words





