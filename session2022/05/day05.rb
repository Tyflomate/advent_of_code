# frozen_string_literal: true

class Day05
  def initialize
    @raw_heaps, @raw_moves = File.read('./05/input.txt').split("\n\n")
  end

  def part1
    heaps = parse_heaps(@raw_heaps)
    parse_moves(@raw_moves).each do |nb, from, to|
      put(heaps[to], take(heaps[from], nb))
    end

    heaps.values.flat_map(&:first).join('')
  end

  def part2
    heaps = parse_heaps(@raw_heaps)
    parse_moves(@raw_moves).each do |nb, from, to|
      put2(heaps[to], take(heaps[from], nb))
    end

    heaps.values.flat_map(&:first).join('')
  end

  private

  def take(heap, nb)
    heap.shift(nb.to_i)
  end

  def put(heap, crates)
    crates.each { heap.unshift(_1) }
  end

  def put2(heap, crates)
    put(heap, crates.reverse)
  end

  def parse_moves(raw_moves)
    raw_moves.lines.map { _1.scan(/\d+/) }
  end

  def parse_heaps(raw_heaps)
    filtered_heaps = raw_heaps.lines(chomp: true)[0..-2].map do |line|
      array = []
      line.chars.each_slice(4) { |a| array << a[1] }
      array
    end

    Hash[filtered_heaps.transpose.each_with_index.map { |line, index| ["#{index + 1}", line.select { _1 != " " }] }]
  end
end

day = Day05.new
puts "Result for part1: #{day.part1}"
puts "Result for part2: #{day.part2}"
