# frozen_string_literal: true

require "pry"

class Day14
  def initialize
    @cave = File.readlines('./14/input.txt', chomp: true).flat_map do |rock_line|
      couples = rock_line.split(' -> ').map { eval("[#{_1}]") }.each_cons(2)
      couples.flat_map do |(x1, y1), (x2, y2)|
        x_min, x_max = [x1, x2].sort
        y_min, y_max = [y1, y2].sort
        (x_min..x_max).to_a.product((y_min..y_max).to_a)
      end
    end.to_h { [_1, 'rock'] }
    @y_max = @cave.keys.max_by { _1[1] }[1]
    @x_start = 500
    @floor = @y_max + 2
  end

  def part1
    drop_sand
    @cave.select { _2 == 'sand' }.size
  end

  def part2
    start = Time.now
    @y_max = @floor
    drop_sand
    finish = Time.now
    puts finish - start
    @cave.select { _2 == 'sand' }.size
  end

  private

  def drop_sand
    drop_sand if drop_sand_particle(@x_start, new_y_start)
  end

  def drop_sand_particle(x, y)
    return false if y >= @y_max
    return false if @cave.has_key?([@x_start, 0])

    next_y = y + 1

    return @cave[[x, y]] = "sand" if next_y == @floor
    return drop_sand_particle(x, next_y) unless @cave.has_key?([x, next_y])

    next_x = x - 1
    return drop_sand_particle(next_x, next_y) unless @cave.has_key?([next_x, next_y])

    next_x = x + 1
    return drop_sand_particle(next_x, next_y) unless @cave.has_key?([next_x, next_y])

    @cave[[x, y]] = "sand"
  end

  def new_y_start
    @cave.keys.select { _1[0] == @x_start }.min[1] - 1
  end
end
