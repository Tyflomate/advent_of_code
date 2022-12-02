# frozen_string_literal: true

class Day02
  POINTS = {
    'X' => 1,
    'Y' => 2,
    'Z' => 3,
  }.freeze

  BATTLES = %w[A Z B X C Y]

  def initialize
    @input = File.readlines('input.txt').map { |line| line.split(' ') }
  end

  def part1
    @input.reduce(0) do |score, (elf, me)|
      score + round_points(me, elf) + POINTS[me]
    end
  end

  def part2
    @input.reduce(0) do |score, (elf, me)|
      score + round_points_bis(me, elf)
    end
  end

  private

  def round_points(me, elf)
    my_index = BATTLES.index(me)
    if BATTLES[my_index - 1] == elf
      0
    elsif BATTLES[(my_index + 1) % BATTLES.size] == elf
      6
    else
      3
    end
  end

  def round_points_bis(me, elf)
    elf_index = BATTLES.index(elf)
    case me
    when 'X'
      0 + POINTS[BATTLES[elf_index + 1]]
    when 'Y'
      3 + POINTS[BATTLES[(elf_index + 3) % BATTLES.size]]
    when 'Z'
      6 + POINTS[BATTLES[elf_index - 1]]
    end
  end
end

day = Day02.new
puts "Result for part1: #{day.part1}"
puts "Result for part2: #{day.part2}"
