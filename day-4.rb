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

def get_card_score(cache, cards, card_index)
  if cache[card_index] then
    return cache[card_index]
  end

  card_copies = get_card_winning_numbers(cards[card_index]).map.with_index { |_, index| index + card_index + 1 }
  cache[card_index] = 1 + card_copies.map { |copy_card_index| get_card_score(cache, cards, copy_card_index) }.reduce(0, :+)
end

def get_total_points(cards)
  cards.map{ |card| (2 ** (get_card_winning_numbers(card).length - 1)).ceil }.reduce(:+)
end

def get_total_score(cards)
  cache = {}
  total_scratchcards_won = 0
  cards.length.times do |card_index|
    total_scratchcards_won += get_card_score(cache, cards, card_index)
  end
  total_scratchcards_won
end

cards = lex_cards(input)
puts get_total_points(cards)
puts get_total_score(cards)
