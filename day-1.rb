INPUT_FILE = "day-1.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

lines = input.split(/\n/, -1).map do |line|
  line_regex = /(?=(three|seven|nine|eight|four|five|six|two|one))|(\d)/
  number_map = {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9
  }
  decoded_line = line.scan(line_regex).flatten.compact.map { |x| number_map[x] || x.to_i }
  pair = [decoded_line[0], decoded_line[decoded_line.length - 1]].reverse
  pair.map.with_index { |x, i| x.to_i * (10 ** i) }.reduce(:+)
end

puts lines.reduce(:+)
