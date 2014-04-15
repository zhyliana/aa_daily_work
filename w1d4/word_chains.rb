require 'set'

class WordChainer
  
  def initialize(dictionary_file_name)
    @dictionary_file_name = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(@dictionary_file_name)
  end
  
  def regexify(word)
    regexed_words = []
    word.length.times do |i|
      regexed_word = word.dup
      regexed_word[i] = "."
      regexed_words << Regexp.new(regexed_word)
    end
    regexed_words
  end
  
  def equally_long_words(word)
    @dictionary.select do |dictionary_word| 
      dictionary_word.length == word.length
    end
  end
  
  def adjacent_words(word)
    dic_words_of_eq_length = equally_long_words(word)
      
    dic_words_of_eq_length.select do |adj_word|
      
      adjacent_factor = regexify(word).none? do |regex| 
        regex =~ adj_word
      end
      
      true unless adjacent_factor || adj_word == word
    end
  end
    
  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}

    until @current_words.empty?
      explore_current_words until @current_words.empty?
    end 
  end
  
  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
          next if @all_seen_words.has_key?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = current_word
      end
    end    
    return new_current_words
    @current_words = new_current_words
  end

  
end

chain = WordChainer.new("dictionary.txt")
p chain.run("cat", "cot")