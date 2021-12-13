defmodule Day11 do
  @moduledoc false

  def add_line_pos({line, y}) do
    line
    |> Enum.with_index
    |> Enum.map(fn {n, x} -> {n, {x,y}} end)
  end

  def input do
    {:ok, input} = File.read('./lib/11/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index
    |> Enum.flat_map(&add_line_pos/1)
    |> Enum.group_by(fn {n, _} -> n end, &elem(&1, 1))
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  defp part1 do
    input()
    nil
  end

  defp part2 do
    #input()
    #|>
    nil
  end
end
