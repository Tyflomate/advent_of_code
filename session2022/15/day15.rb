# frozen_string_literal: true

require "pry"

class Day15
  def initialize
    @input = File.readlines('./15/input.txt', chomp: true).to_h do |line|
      (sx, sy), (bx, by) = line.scan(/-?\d+/).map(&:to_i).each_slice(2).to_a
      [[sx, sy], manhattan(sx, sy, bx, by)]
    end
  end

  def part1
    @y = 2000000
    (populate_busy_pos - @input.values).size
  end

  def part2
    @limit = 4000000
    start = Time.now
    position = check_positions
    finish = Time.now
    puts "Execution time: #{finish - start}"
    position[0] * 4000000 + position[1]
  end

  private

  def populate_busy_pos
    busy_pos_at_y = Set.new([])
    @input.each do |(sx, sy), d|
      max_x = sx + d
      min_x = sx - d
      max_y = sy + d
      min_y = sy - d
      next unless @y <= max_y && @y >= min_y
      diff = (@y - sy).abs
      x_left = min_x + diff
      x_right = max_x - diff
      (x_left..x_right).each do |x|
        busy_pos_at_y.add([x, @y])
      end
    end
    busy_pos_at_y
  end

  def check_positions
    @input.each do |(sx, sy), d|
      d = d + 1
      max_x = sx + d
      min_x = sx - d
      (0..d).each do |current_distance|
        y_up = sy - current_distance
        y_down = sy + current_distance
        x_left = min_x + current_distance
        x_right = max_x - current_distance
        possible_pos = [[x_left, y_up], [x_left, y_down], [x_right, y_up], [x_right, y_down]].uniq
        possible_pos.each do |x, y|
          next if x > @limit || x < 0 || y > @limit || y < 0
          return [x, y] if position_available?(x, y)
        end
      end
    end
  end

  def position_available?(x, y)
    @input.select { |sensor, d| position_inside?(x, y, sensor, d) }.empty?
  end

  def position_inside?(x, y, (sx, sy), d)
    manhattan(x, y, sx, sy) <= d
  end

  def manhattan(x1, y1, x2, y2)
    (x1 - x2).abs + (y1 - y2).abs
  end
end
