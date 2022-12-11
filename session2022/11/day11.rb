# frozen_string_literal: true

require "pry"

class Day11
  def initialize
    @monkeys = File.read('./11/input.txt', chomp: true).split("\n\n").map do |monkey_instruction|
      instructions = monkey_instruction.split("\n").drop(1)
      items = instructions[0].scan(/\d+/).map(&:to_i)
      operation = instructions[1].split(' = ').last
      divider = instructions[2].scan(/\d+/).first.to_i
      monkey_if_true = instructions[3].scan(/\d+/).first.to_i
      monkey_if_false = instructions[4].scan(/\d+/).first.to_i
      test = "divisible_by?(new, #{divider}) ? #{monkey_if_true} : #{monkey_if_false}"
      { items: items, operation: operation, test: test, items_watched: 0 }
    end
  end

  def part1
    20.times do
      @monkeys.each do |monkey|
        monkey[:items].each do |old|
          new = eval(monkey[:operation]) / 3
          monkey_to_pass = eval(monkey[:test])
          @monkeys[monkey_to_pass][:items] << new
          monkey[:items_watched] += 1
        end
        monkey[:items] = []
      end
    end

    @monkeys.map { _1[:items_watched] }.max(2).reduce(:*)
  end

  def part2
    modulo = @monkeys.map{ _1[:test].scan(/\d+/).first.to_i }.reduce(:*)
    10_000.times do |round|
      puts round
      @monkeys.each do |monkey|
        items = monkey[:items]
        items.each do |old|
          new = eval(monkey[:operation]) % modulo
          monkey_to_pass = eval(monkey[:test])
          @monkeys[monkey_to_pass][:items] << new
        end
        monkey[:items_watched] += items.size
        monkey[:items] = []
      end
    end

    @monkeys.map { _1[:items_watched] }.max(2).reduce(:*)
  end

  private

  def divisible_by?(x, y)
    x % y == 0
  end
end
