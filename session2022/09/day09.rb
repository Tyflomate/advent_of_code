# frozen_string_literal: true

require "pry"

class Day09
  BASE_POS = [0, 0]

  def initialize
    @input = File.readlines('./09/input.txt', chomp: true).map do |line|
      direction, step = line.split(' ')
      [direction, step.to_i]
    end
  end

  def part1
    @positions = Array.new(2) { BASE_POS.dup }
    @pos_visited = Set.new([BASE_POS.dup])
    @input.each do |(direction, steps)|
      steps.times { move(direction) }
    end
    @pos_visited.size
  end

  def part2
    @positions = Array.new(10) { BASE_POS.dup }
    @pos_visited = Set.new([BASE_POS.dup])
    @input.each do |(direction, steps)|
      steps.times { move(direction) }
    end
    @pos_visited.size
  end

  private

  def move(direction)
    send("move_head_#{direction}")
    (1...@positions.size).each do |tail_id|
      move_tail(tail_id)
    end
    @pos_visited.add(@positions.last)
  end

  def move_tail(tail_id)
    tail_x, tail_y = @positions[tail_id]
    ref_x, ref_y = @positions[tail_id - 1]
    new_x, new_y = tail_x, tail_y
    x_diff = ref_x - tail_x
    y_diff = ref_y - tail_y
    if x_diff.abs > 1
      new_x += x_diff > 0 ? 1 : -1
      new_y += y_diff > 0 ? 1 : -1 if y_diff != 0
    elsif y_diff.abs > 1
      new_y += y_diff > 0 ? 1 : -1
      new_x += x_diff > 0 ? 1 : -1 if x_diff != 0
    end
    @positions[tail_id] = [new_x, new_y]
  end

  def move_head_R
    @positions[0][0] += 1
  end

  def move_head_L
    @positions[0][0] -= 1
  end

  def move_head_U
    @positions[0][1] += 1
  end

  def move_head_D
    @positions[0][1] -= 1
  end
end
