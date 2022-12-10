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
    @cycles_instruction.each_with_index do |v, i|
      draw(i)
      @x += v
    end
  end

  private

  def draw(index)
    crt_x = index % @width
    char = sprite_pixels.include?(crt_x) ? '#' : ' '
    print "#{crt_x == 0 ? "\n": ""}#{char}"
  end

  def sprite_pixels
    [@x - 1, @x, @x + 1]
  end
end
