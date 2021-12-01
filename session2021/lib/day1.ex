defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  def input do
    {:ok, input} = File.read('./inputs/input1.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solution do
    %{ "part1" => part1(), "part2" => part2() }
  end

  defp part1 do
    count_increased_values(input())
  end

  defp part2 do
  end

  defp count_increased_values(array) do
    [head | tails] = array
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

  defp group_and_sum_by_3(array) do
    case array do
      [h1 | [h2 | [h3 | tails]]] ->
    end
  end
end
