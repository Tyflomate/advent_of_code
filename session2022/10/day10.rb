# frozen_string_literal: true

class Day10
  def initialize
    @cycles_instruction = File.readlines('./10/input.txt', chomp: true).flat_map do |line|
      command, maybe_v = line.split(' ')
      if command == 'noop'
        0
      else
        [0, maybe_v.to_i]
      end
    end
    @x = 1
    @width = 40
    @height = @cycles_instruction.size / 40
  end

  def part1
    @cycles_instruction.each.with_index(1).reduce(0) do |acc, (v, i)|
      acc += i * @x if (i + 20) % 40 == 0
      @x += v
      acc
    end
  end

  def part2
    @crt = Array.new(@height) { ' ' * @width }

    @cycles_instruction.each_with_index do |v, i|
      draw(i)
      @x += v
    end

    @crt.each { puts _1 }
  end

  private

  def draw(index)
    x, y = crt_pos(index)
    @crt[y][x] = '#' if sprite_pixels.include?(x)
  end

  def sprite_pixels
    [@x - 1, @x, @x + 1]
  end

  def crt_pos(index)
    [index % @width, index / @width]
  end
end
