defmodule Day3 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/03/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def part1 do
    [binary_gamma, binary_epsilon] =
      input()
      |> List.zip
      |> Enum.map(&min_max_from(Tuple.to_list(&1)))
      |> List.zip
      |> Enum.map(&List.to_string(Tuple.to_list(&1)))
    String.to_integer(binary_gamma, 2) * String.to_integer(binary_epsilon, 2)
  end

  def min_max_from(binary_list) do
    {{min, _}, {max, _}} =
      binary_list
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {x, value} -> {value, x} end)

    [min, max]
  end

  def rate_from_input([], _, _) do [] end
  def rate_from_input([x | []], _, _), do: x
  def rate_from_input(input, index, oxygen_rate?) do
    [min, max] = input |> List.zip |> Enum.at(index) |> Tuple.to_list |> Day3.min_max_from
    checked_value = if oxygen_rate?, do: max, else: min

    input
    |> Enum.filter(fn xs -> Enum.at(xs, index) == checked_value end)
    |> rate_from_input(index + 1, oxygen_rate?)
  end

  def oxygen_rate(input, index \\ 0)
  def oxygen_rate(input, index) do
    rate_from_input(input, index, true) |> List.to_string |> String.to_integer(2)
  end

  def co2_rate(input, index \\ 0)
  def co2_rate(input, index) do
    rate_from_input(input, index, false) |> List.to_string |> String.to_integer(2)
  end

  def part2 do
    oxygen_rate = input() |> oxygen_rate
    co2_rate = input() |> co2_rate
    oxygen_rate * co2_rate
  end
end
