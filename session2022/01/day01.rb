# frozen_string_literal: true

class Day01
  def initialize
    input = File.open('input.txt').read
    @input = input.split("\n\n").map{|line| line.lines.map(&:to_i)}
  end

  def part1
    calories_by_elf.max
  end

  def part2
    calories_by_elf.max(3).sum
  end

  private

  def calories_by_elf
    @input.map(&:sum)
  end
end

day = Day01.new
puts "Result for part1: #{day.part1}"
puts "Result for part2: #{day.part2}"
