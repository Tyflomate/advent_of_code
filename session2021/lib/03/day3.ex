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
      |> Enum.min_max_by(fn {_, value} -> value end)

    [min, max]
  end

  def part2 do
    input()
    #|>
  end
end
