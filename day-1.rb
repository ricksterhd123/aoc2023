INPUT_FILE = "day-1.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

lines = input.split(/\n/, -1).map do |line|
  decoded_line = line.split('').filter { |x| /\d/.match?(x) }.reverse
  pair = [decoded_line[0], decoded_line[decoded_line.length - 1]]
  pair.map.with_index { |x, i| x.to_i * (10 ** i) }.reduce(:+)
end

puts lines.reduce(:+)
