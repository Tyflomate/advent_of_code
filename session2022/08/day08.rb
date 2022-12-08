# frozen_string_literal: true

class Day08
  def initialize
    @input = parse_input(File.readlines('./08/input.txt', chomp: true))
  end

  def part1
    pos_visible = Set.new([])
    @input.each do |tree_line|
      tree_sizes = tree_line.map { _1[1] }
      tree_line.each_with_index do |(pos, tree_size), i|
        precedents = tree_sizes[..i - 1]
        pos_visible.add(pos) if i == 0 || (!precedents.include?(tree_size) && (precedents << tree_size).max == tree_size)
      end
    end

    pos_visible.size
  end

  def part2
    tree_scenic_scores = Hash.new(1)

    @input.each do |tree_line|
      tree_sizes = tree_line.map { _1[1] }
      tree_line.each_with_index do |(pos, tree_size), i|
        precedents = tree_sizes[..i - 1]
        scenic_view = i == 0 ? 0 : count_scenic_view(precedents.reverse, tree_size)
        tree_scenic_scores[pos] = tree_scenic_scores[pos] * scenic_view
      end
    end

    tree_scenic_scores.values.max
  end

  private

  def count_scenic_view(precedents, tree_size, count = 1)
    first, *rest = *precedents
    return count if rest.empty? || first >= tree_size
    count_scenic_view(rest, tree_size, count + 1)
  end

  def parse_input(input)
    lines = input.map(&:chars).each_with_index.map do |line, y|
      line.each_with_index.map do |tree_size, x|
        ["#{x},#{y}", tree_size.to_i]
      end
    end
    lines_and_columns = lines + lines.transpose
    lines_and_columns + lines_and_columns.map(&:reverse)
  end
end
