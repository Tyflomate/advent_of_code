# frozen_string_literal: true

require "pry"

class Day09
  BASE_POS = { x: 0, y: 0 }

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
      move(direction, steps)
    end
    @pos_visited.size
  end

  def part2
    @positions = Array.new(10) { BASE_POS.dup }
    @pos_visited = Set.new([BASE_POS.dup])
    @input.each do |(direction, steps)|
      move(direction, steps)
    end
    @pos_visited.size
  end

  private

  def move(direction, steps)
    send("move_head_#{direction}", steps)
    (1...@positions.size).each do |tail_id|
      move_tail(direction, tail_id)
    end
  end

  def move_tail(direction, tail_id)
    ref_pos = @positions[tail_id - 1]
    tail_pos = @positions[tail_id]
    new_pos, new_poses = send("move_tail_#{direction}", tail_pos, ref_pos)
    binding.pry
    @positions[tail_id] = new_pos if new_pos
    @pos_visited += (new_poses || [])
  end

  def move_head_R(steps)
    @positions[0][:x] += steps
  end

  def move_tail_R(tail_pos, ref_pos)
    if tail_pos[:x] < ref_pos[:x] - 1
      new_pos = { x: ref_pos[:x] - 1, y: ref_pos[:y] }
      new_poses = (tail_pos[:x] + 1...ref_pos[:x]).map { { x: _1, y: ref_pos[:y] } }
      [new_pos, new_poses]
    end
  end

  def move_head_L(steps)
    @positions[0][:x] -= steps
  end

  def move_tail_L(tail_pos, ref_pos)
    if tail_pos[:x] > ref_pos[:x] + 1
      new_pos = { x: ref_pos[:x] + 1, y: ref_pos[:y] }
      new_poses = (ref_pos[:x] + 1...tail_pos[:x]).map { { x: _1, y: ref_pos[:y] } }
      [new_pos, new_poses]
    end
  end

  def move_head_U(steps)
    @positions[0][:y] += steps
  end

  def move_tail_U(tail_pos, ref_pos)
    if tail_pos[:y] < ref_pos[:y] - 1
      new_pos = { x: ref_pos[:x], y: ref_pos[:y] - 1 }
      new_poses = (tail_pos[:y] + 1...ref_pos[:y]).map { { x: ref_pos[:x], y: _1 } }
      [new_pos, new_poses]
    end
  end

  def move_head_D(steps)
    @positions[0][:y] -= steps
  end

  def move_tail_D(tail_pos, ref_pos)
    if tail_pos[:y] > ref_pos[:y] + 1
      new_pos = { x: ref_pos[:x], y: ref_pos[:y] + 1 }
      new_poses = (ref_pos[:y] + 1...tail_pos[:y]).map { { x: ref_pos[:x], y: _1 } }
      [new_pos, new_poses]
    end
  end
end
