# frozen_string_literal: true

class Day04
  def initialize
    @input = File.readlines('./04/input.txt', chomp: true).map do |assignment|
      assignment.split(/[,-]/).map(&:to_i).each_slice(2).map{|a, b| (a..b).to_a}
    end
  end

  def part1
    @input.reduce(0) do |score, (r1, r2)|
      next score + 1 if (r1 - r2).empty? || (r2 - r1).empty?

      score
    end
  end

  def part2
    @input.reduce(0) do |score, (r1, r2)|
      next score if (r1 & r2).empty?

      score + 1
    end
  end
end

day = Day04.new
puts "Result for part1: #{day.part1}"
puts "Result for part2: #{day.part2}"
