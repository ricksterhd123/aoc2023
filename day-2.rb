require 'json'

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

  # get the highest number in each game for each colour
  red = flattened_game_sets.filter { |game| game[1] == "red" }.sort { |game1, game2| game2[0] <=> game1[0] }[0][0]
  green = flattened_game_sets.filter { |game| game[1] == "green" }.sort { |game1, game2| game2[0] <=> game1[0] }[0][0]
  blue = flattened_game_sets.filter { |game| game[1] == "blue" }.sort { |game1, game2| game2[0] <=> game1[0] }[0][0]

  [red, green, blue, game_number]
end

puts lines.filter { |game| game => [red, green, blue, _]; red <= 12 and green <= 13 and blue <= 14 }.map { |game| game[3] }.reduce(:+)
