require 'json'

INPUT_FILE = "day-3.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

# this is a symbol?
def is_symbol(input_str)
  if input_str.length <= 0 then
    false
  else
    input_str.match?(/[^\.|\d]/)
  end
end

def check_engine_number(input_lines, token)
  token => [engine_number, [line_number, match_index, match_length]]
  total_lines = input_lines.length

  puts engine_number

  line_numbers = [[0, line_number - 1].max, line_number, [line_number + 1, total_lines - 1].min].uniq

  puts JSON.dump(line_numbers)

  is_engine_number = line_numbers.map do |current_line|
    if current_line == line_number
      # check -1 and +1 only
      left = match_index > 0 ? input_lines[current_line][match_index - 1] : ""
      right = (match_index + match_length) < input_lines[current_line].length ? input_lines[current_line][match_index + match_length] : ""

      puts JSON.dump([left, right])

      is_symbol(left) or is_symbol(right)
    else
      # check -1 ...<length_of_word>... +1
      check_slice = input_lines[current_line]
      .slice([0, match_index - 1].max, match_length + 2)

      puts JSON.dump(check_slice)

      check_slice
      .split('').reduce(false) { |next_to_symbol, char| next_to_symbol or is_symbol(char) }
    end
  end.any?

  puts is_engine_number

  is_engine_number
end

# Simple lexer returns a list of [number, [{line_number}, {match_index}, {match_length}]]
# it should provide enough info to check adjecent characters for symbols
def lexer(input_lines)
  input_lines.map.with_index do |line, line_number|
    tokens = []
    line.scan(/\d+/) do |c|
      tokens << [c.to_i, [line_number, $~.offset(0)[0], c.length]]
    end
    tokens
  end
  .reduce([], :concat)
end

input_lines = input.split(/\n/)
tokens = lexer(input_lines)

engine_numbers = tokens.filter_map { |token| token[0] if check_engine_number(input_lines, token) }
puts JSON.dump(engine_numbers)
puts JSON.dump(engine_numbers.reduce(:+))
