# frozen_string_literal: true

require "pry"

class Day06
  def initialize
    @input = File.readlines('./06/input.txt', chomp: true).first
  end

  def part1
    c1, c2, c3, c4, *rest = *@input.chars
    search([c1,c2,c3,c4], rest, 4)
  end

  def part2
    chars = @input.chars
    search(chars.first(14), chars.drop(14), 14)
  end

  private

  def search(chars, rest, nb_parsed_characters)
    return nb_parsed_characters unless chars.find{ |c| chars.count(c) > 1 }
    a, *tail = *rest

    search(chars.drop(1) << a, tail, nb_parsed_characters + 1)
  end
end
