require 'json'

INPUT_FILE = "day-3.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

# this is a symbol?
def parse_symbol(input_str)
  if input_str and input_str.match?(/\.|\d/) then
    nil
  elsif input_str.match?(/\*/)
    :gear
  else
    :symbol
  end
end

def parse_engine_number(input_lines, token)
  token => [engine_number, [line_number, match_index, match_length]]
  total_lines = input_lines.length

  puts engine_number

  line_numbers = [[0, line_number - 1].max, line_number, [line_number + 1, total_lines - 1].min].uniq

  # puts JSON.dump(line_numbers)

  is_engine_number = line_numbers.filter_map do |current_line|
    if current_line == line_number
      # check -1 and +1 only
      left = match_index > 0 ? match_index - 1 : nil
      right = (match_index + match_length) < input_lines[current_line].length ? match_index + match_length : nil

      # puts JSON.dump([left, right])

      results = [left, right].filter_map { |index| symbol = !index.nil? && parse_symbol(input_lines[current_line][index]); [current_line, index, symbol] if symbol }

      puts JSON.dump(results)

      results
    else
      start_index = [0, match_index - 1].max
      end_index = match_length + 2

      # check -1 ...<length_of_word>... +1
      check_slice = input_lines[current_line]
      .slice(start_index, end_index)

      puts JSON.dump(check_slice)

      results = check_slice
      .split('').filter_map.with_index { |char, index| symbol = parse_symbol(char); [current_line, index + start_index, symbol] if symbol }

      puts JSON.dump(results)

      results
    end
  end

  [engine_number, is_engine_number.reduce(:concat)]
end

# Simple lexer returns list of tokens of [engine_number, [{line_number}, {match_index}, {match_length}]]
# it should provide enough info to check adjecent characters for symbols
def lexer(input_lines)
  input_lines.map.with_index do |line, line_number|
    tokens = []
    line.scan(/\d+/) do |c|
      tokens << [c.to_i, [line_number, Regexp.last_match.offset(0)[0], c.length]]
    end
    tokens
  end
  .reduce([], :concat)
end

input_lines = input.split(/\n/)
tokens = lexer(input_lines)

engine_numbers = tokens
.filter_map { |token| parse_engine_number(input_lines, token) }
.filter { |token| token[1].length > 0 }

# puts JSON.dump(engine_numbers)
# puts JSON.dump(engine_numbers.map { |token| token[0] }.reduce(:+))

engine_gear_numbers = engine_numbers.filter { |token| token[1].select { |symbol| symbol[2] == :gear }.first }

engine_gears = {}

for engine_gear_number in engine_gear_numbers do
  engine_gear_number => [engine_number, symbols]

  for symbol in symbols.filter { |symbol| symbol[2] == :gear } do
    symbol => [match_index, line_index, symbol_type]
    symbol_id = "#{match_index}-#{line_index}-#{symbol_type}"

    if not engine_gears[symbol_id] then
      engine_gears[symbol_id] = []
    end

    engine_gears[symbol_id].push(engine_number)
  end
end

puts JSON.dump(engine_gears.to_a.filter { |key, value| value.length > 1 }.map { |_, value| value.reduce(:*) }.reduce(:+))
