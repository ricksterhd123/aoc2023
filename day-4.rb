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

def get_card_winning_numbers(card)
  card => [_, winning_numbers, card_numbers]
  (winning_numbers & card_numbers)
end

def get_card_points1(card)
  winning_card_numbers = get_card_winning_numbers(card)
  winning_card_numbers.length > 0 ? 2 ** (winning_card_numbers.length - 1) : 0
end

cards = lex_cards(input)

card_score_map = {}
card_map = {}

for card in cards do
  card => [card_index, _, _]
  winning_card_numbers = get_card_winning_numbers(card)
  card_map[card_index] = winning_card_numbers.map.with_index { |_, i| card_index + i + 1 }
  card_score_map[card_index] = winning_card_numbers.length
end

def get_card_copies(cache, card_map, card_index)
  if cache[card_index] then
    return cache[card_index]
  end

  card_copies = card_map[card_index]
  if card_copies.length > 0
    cache[card_index] = [card_index, card_copies.map { |copy_card_index| get_card_copies(cache, card_map, copy_card_index) }.flatten]
  else
    cache[card_index] = [card_index]
  end
end

cache = {}

puts JSON.dump(cards.map{ |card| get_card_points1(card) }.reduce(:+))
puts JSON.dump(
  cards
  .sort { |card_a, card_b| card_score_map[card_a[0]] <=> card_score_map[card_b[0]]}
  .reduce(0) { |acc, card| acc + get_card_copies(cache, card_map, card[0]).flatten.length }
)
