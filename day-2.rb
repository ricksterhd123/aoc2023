INPUT_FILE = "day-2.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

lines = input.split(/\n/).map do |line|
  game_meta, game = line.split(/: /)
  _, game_number = game_meta.split(/ /)

  flattened_game_sets = game.split(/;/).map { |set|
    set.strip.split(/, /).map { |draw|
      match = /(\d+) (red|green|blue)/.match(draw)
      [match[1].to_i, match[2]]
    }
  }.reduce([], :concat)

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

  [red, green, blue, red + green + blue, game_number.to_i]
end

puts lines
.sort { |game1, game2| game2[3] <=> game1[3] }  # total the maxes and sort descending
.filter_map { |game| game => [red, green, blue, _, _]; game[4] if red <= 12 and green <= 13 and blue <= 14 }
.reduce(:+)
