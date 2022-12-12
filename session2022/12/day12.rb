# frozen_string_literal: true

require 'pry'

class Day12
  def initialize
    @input = File.readlines('./12/input.txt', chomp: true).each_with_index.flat_map do |line, y|
      line.chars.each_with_index.map do |char, x|
        pos = [x, y]
        if char == 'S'
          @start = pos
          char = 'a'
        elsif char == 'E'
          @end = pos
          char = 'z'
        end
        [pos, char.ord]
      end
    end.to_h
    @arcs = @input.to_h do |pos, summit_size|
      x, y = pos
      neighbors = [[x+1, y], [x-1, y], [x, y-1], [x, y+1]]
                    .select{@input.has_key?(_1)}
                    .map{[_1, @input[_1]]}
                    .select{_2 < summit_size + 2}
                    .map(&:first)
      [pos, neighbors]
    end
  end

  def part1
    shortest_path(@start, @end)
  end

  def part2
    @input.select{_2 == 'a'.ord}.keys.reduce(Float::INFINITY) do |acc, start|
      steps = shortest_path(start, @end) || Float::INFINITY
      [acc, steps].min
    end
  end

  def shortest_path(start, goal)
    visited = Set.new([])
    to_visit = [[start, 0]]
    while !to_visit.empty? do
      current_summit, current_distance = to_visit.shift
      return current_distance if current_summit == goal

      neighbours = @arcs[current_summit]
      neighbours.each do |neighbor|
        to_visit << [neighbor, current_distance + 1] unless visited.include?(neighbor)
      end
      to_visit = to_visit.uniq
      visited.add(current_summit)
    end
  end
end
