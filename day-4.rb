require 'json'

INPUT_FILE = "day-4.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

def lex_cards(input)
  input_lines = input.split(/\n/)
  input_lines.map do |line|
    line_match = line.match(/Card\s*(\d+):\s*([\d+\s*]+)\s*\|\s*([\d+\s*]+)/)
    card_index = line_match[1].to_i
    winning_numbers = line_match[2].split(' ').map { |n| n.to_i }
    card_numbers = line_match[3].split(' ').map { |n| n.to_i }

    [card_index, winning_numbers.to_set, card_numbers.to_set]
  end
end

def scratch_card(card)
  card => [_, winning_numbers, card_numbers]
  winning_card_numbers = (winning_numbers & card_numbers)
  winning_card_numbers.length > 0 ? 2 ** (winning_card_numbers.length - 1) : 0
end

puts JSON.dump(lex_cards(input).map{ |card| scratch_card(card) }.reduce(:+))
