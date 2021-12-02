defmodule Day2 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/02/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&format_input/1)
  end

  def format_input(string) do
    [first | [second | []]] = String.split(string, " ", trim: true)
    {first, String.to_integer(second)}
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  defp part1 do
    input()
    |> count_position
    |> Tuple.product
  end

  defp part2 do
    {x, y, _} = input() |> count_position_with_aim
    x * y
  end

  defp count_position(list) do
    list
    |> List.foldl({0, 0}, &compute_new_position/2)
  end

  defp compute_new_position({direction, amount}, {x, y}) do
    case direction do
      "forward" -> {x + amount, y}
      "down" -> {x, y + amount}
      "up" -> {x, y - amount}
    end
  end

  def count_position_with_aim(list) do
    list
    |> List.foldl({0, 0, 0}, &compute_new_position_with_aim/2)
  end

  defp compute_new_position_with_aim({direction, amount}, {x, y, aim}) do
    case direction do
      "forward" -> {x + amount, amount * aim + y, aim}
      "down" -> {x, y, aim + amount}
      "up" -> {x, y, aim - amount}
    end
  end
end
