# frozen_string_literal: true

class Day13
  def part1
    packets_in_pair = File.read('./13/input.txt', chomp: true).split("\n\n").map do |pairs|
      pairs.lines.map { eval(_1) }
    end
    packets_in_pair.each_with_index.reduce([]) do |acc, (pair, index)|
      pair_ordered?(pair) ? acc << index + 1 : acc
    end.sum
  end

  def part2
    packets = File.readlines('./13/input.txt', chomp: true).map { eval(_1) }.compact
    packets += [[[2]],[[6]]]
    packets.sort!{ pair_diff(_1, _2)}
    (packets.index([[2]]) + 1) * (packets.index([[6]]) + 1)
  end

  private

  def pair_ordered?((left, right))
    pair_diff(left, right) <= 0
  end

  def pair_diff(left, right)
    return pair_diff(Array(left), Array(right)) if left.class != right.class
    return left - right if left.instance_of?(Integer)
    return 0 if right.empty? && left.empty?
    return 1 if right.empty?
    return -1 if left.empty?

    left, *left_rest = *left
    right, *right_rest = *right
    diff = pair_diff(left, right)
    return diff unless diff == 0

    pair_diff(left_rest, right_rest)
  end
end
