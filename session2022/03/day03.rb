# frozen_string_literal: true

class Day03
  CHARACTERS = [nil] + ('a'..'z').to_a + ('A'..'Z').to_a

  def initialize
    @input = File.readlines('./03/input.txt', chomp: true)
  end

  def part1
    @input.reduce(0) do |score, rucksack|
      item, _ = rucksack.chars.each_slice(rucksack.size / 2).to_a.reduce(&:&)
      score + CHARACTERS.index(item)
    end
  end

  def part2
    @input.each_slice(3).reduce(0) do |score, (a, b, c)|
      badge, _ = a.chars & b.chars & c.chars
      score + CHARACTERS.index(badge)
    end
  end
end

day = Day03.new
puts "Result for part1: #{day.part1}"
puts "Result for part2: #{day.part2}"
