require 'json'

INPUT_FILE = "day-3.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

def lex_symbol(input_str)
  if input_str and input_str.match?(/\.|\d/) then
    nil
  elsif input_str.match?(/\*/)
    :gear
  else
    :symbol
  end
end

def lex_engine_number(input_lines, token)
  token => [engine_number, [line_number, match_index, match_length]]
  total_lines = input_lines.length

  line_numbers = [[0, line_number - 1].max, line_number, [line_number + 1, total_lines - 1].min].uniq

  symbols = line_numbers.filter_map do |current_line|
    if current_line == line_number
      # check -1 and +1 only
      left = match_index > 0 ? match_index - 1 : nil
      right = (match_index + match_length) < input_lines[current_line].length ? match_index + match_length : nil
      [left, right].filter_map { |index| symbol = !index.nil? && lex_symbol(input_lines[current_line][index]); [current_line, index, symbol] if symbol }
    else
      start_index = [0, match_index - 1].max
      end_index = match_length + 2

      # check -1 ...<length_of_word>... +1
      input_lines[current_line]
      .slice(start_index, end_index)
      .split('').filter_map.with_index { |char, offset| symbol = lex_symbol(char); [current_line, start_index + offset, symbol] if symbol }
    end
  end

  [engine_number, symbols.reduce(:concat)]
end

# returns list of engine_numbers that have symbols adjacent (by definition)
def lexer(input)
  input_lines = input.split(/\n/)
  tokens = input_lines.map.with_index do |line, line_number|
    tokens = []
    line.scan(/\d+/) do |c|
      tokens << [c.to_i, [line_number, Regexp.last_match.offset(0)[0], c.length]]
    end
    tokens
  end
  .reduce([], :concat)

  tokens
  .filter_map { |token| lex_engine_number(input_lines, token) }
  .filter { |_, symbols| symbols.length > 0 }
end

engine_numbers = lexer(input)

## First part of solution
## get a list of all engine numbers and add them
puts JSON.dump(engine_numbers.map { |engine_number, _| engine_number }.reduce(:+))

## Second part of solution
## Filter all the engine numbers that are next to gears
## go through each engine numbers and their adjacent symbols and collect
## a list of engine numbers for each gear symbol
engine_gear_numbers = engine_numbers.filter { |_, symbols| symbols.select { |_, _, symbol| symbol == :gear }.first }
engine_gears = {}

for engine_gear_number in engine_gear_numbers do
  engine_gear_number => [engine_number, symbols]

  for symbol in symbols.filter { |_, _, symbol| symbol == :gear } do
    symbol => [match_index, line_index, symbol_type]
    symbol_id = "#{match_index}-#{line_index}-#{symbol_type}"

    if not engine_gears[symbol_id] then
      engine_gears[symbol_id] = []
    end

    engine_gears[symbol_id].push(engine_number)
  end
end

puts JSON.dump(
  engine_gears
  .to_a.filter { |symbol_id, engine_numbers| engine_numbers.length > 1 }
  .map { |_, engine_numbers| engine_numbers.reduce(:*) }
  .reduce(:+)
)
