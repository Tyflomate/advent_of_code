defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  def input do
    {:ok, input} = File.read('./lib/01/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solution do
    %{ "part1" => part1(), "part2" => part2() }
  end

  defp part1 do
    input()
    |> count_increased_values
  end

  defp part2 do
    input()
    |> Enum.chunk_every(3, 1, [])
    |> Enum.map(&Enum.sum/1)
    |> count_increased_values
  end

  defp count_increased_values([head | tails]) do
    tails
    |> List.foldl(
         {0, head},
         fn (cur, acc) ->
           case acc do
             {counter, prev} when cur > prev -> {counter + 1, cur}
             {counter, _} -> {counter, cur}
           end
         end
       )
    |> elem(0)
  end
end
