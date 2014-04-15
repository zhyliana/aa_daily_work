def substrings(word)
  subs = []
  start = 0

  # (0...word.length).each do |start|
  # word.length.times do |start|
  while start < word.length
    stop = start

    # (start...word.length).each do |stop|
    while stop < word.length
      current = word[start..stop]
      subs << current unless subs.include?(current)

      stop+=1
    end

    start+=1
  end
  subs
end

require 'set'

def subwords(words)
  text = Set.new

  # dict_words = File.readlines("dictionary.txt").map(&:chomp)
  File.open("dictionary.txt") do |file|
    file.each_line { |line| text << line.chomp }
  end
  # f = File.open("dictionary.txt").each_line { |line| text << line.chomp }
  # f.close
  # p f.closed?

  words.select { |word| text.include?(word)}
end

p subwords(substrings("word"))
