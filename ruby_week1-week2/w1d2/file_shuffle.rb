def file_shuffler
  shuffled_file = []
  puts "what is the file name?"
  file_name = gets.chomp
  File.open(file_name).each_line do |line|
    shuffled_file << line.chomp
  end
  File.open("#{file_name}-shuffled.txt", "w") do |f|
      f.write("#{shuffled_file.shuffle}")
  end

end

file_shuffler