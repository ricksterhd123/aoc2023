INPUT_FILE = "day-2.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

lines = input.split(/\n/).map do |line|
  game_meta, game = line.split(/: /)
  game_meta_match = game_meta.match(/Game (\d+)/)
  game_number = game_meta_match[1].to_i

  game_sets = game.split(/;/).map { |set| set.strip.split(/, /).map do |draw|
    match = /(\d+) (red|green|blue)/.match(draw)
    [match[1].to_i, match[2]]
  end }

  flattened_game_sets = game_sets.reduce([], :concat)

  red, green, blue = [0, 0, 0]
  for n, color in flattened_game_sets do
    if color == "red" and red < n then
      red = n
    elsif color == "green" and green < n then
      green = n
    elsif color == "blue" and blue < n then
      blue = n
    end
  end

  total = red + green + blue
  [red, green, blue, total, game_number]
end

puts lines
.sort { |game1, game2| game2[3] <=> game1[3] }
.filter { |game| game => [red, green, blue, _, _]; red <= 12 and green <= 13 and blue <= 14 }
.map { |game| game[4] }
.reduce(:+)
