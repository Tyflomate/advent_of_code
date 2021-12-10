defmodule Day8 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/08/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn ele -> String.split(ele, " | ", trim: true) |> Enum.at(1) end)
    |> Enum.flat_map(&String.split(&1, " ", trim: true))
  end

  def obvious_length(string), do: String.length(string) |> Kernel.in([2, 3, 4, 7])

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  defp part1 do
    input()
    |> Enum.filter(&obvious_length/1)
    |> Enum.count
  end

  defp part2 do
    input()
    #|>
  end
end
