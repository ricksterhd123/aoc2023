require 'json'

INPUT_FILE = "day-5.input.txt"

file = File.open(INPUT_FILE)
input = file.read
file.close

seeds = input.scan(/seeds: ((?:\d+ ?)+)/)[0][0].split(' ').map(&:to_i)

sub_maps = input.scan(/(?:(\w+)-to-(\w+)+) map:\s((?:\d+ \d+ \d+\s?)+)/).map { |source_key, destination_key, ranges|
  {
    :source => source_key,
    :destination => destination_key,
    # dest_range source_range range_length
    :ranges => ranges
      .split(/\n/).map { |line| line.split(' ').map(&:to_i) }
  }
}

# Creates a composed function which maps input from source to destination, e.g. seed to location
def build_src_dest_fn(sub_maps, source_key = 'seed', destination_key = 'location')
  paths = []
  next_source = source_key

  until next_source == destination_key do
    pathlet = sub_maps.select { |sub_map| sub_map[:source] == next_source }.first
    next_source = pathlet[:destination]
    paths.push(pathlet)
  end

  # Map each path into lambda function and compose them
  paths
    .map { |path|
    lambda do |input|
      range = path[:ranges].filter { |dest, source, range_length| source <= input and input < source + range_length }.first

      if not range then
        return input
      end

      range[0] + (input - range[1])
    end
  }
  .reduce { |acc, fn| acc ? fn << acc : fn }
end

get_location_from_seed = build_src_dest_fn(sub_maps)
puts JSON.dump(seeds.map(&get_location_from_seed).sort.first)
