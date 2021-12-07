defmodule Day5 do
  @moduledoc false

  def coordinate_to_tuple(coord) do
    coord
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  def coordinates_line_to_tuple(line) do
    line
    |> String.split(" -> ", trim: true)
    |> Enum.map(&coordinate_to_tuple/1)
    |> List.to_tuple
  end

  def input do
    {:ok, input} = File.read('./lib/05/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&coordinates_line_to_tuple/1)
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def horizontal_or_vertical?({{x, _}, {x, _}}), do: true
  def horizontal_or_vertical?({{_, y}, {_, y}}), do: true
  def horizontal_or_vertical?(_), do: false

  def coords_to_points({{x, y1}, {x, y2}}) do
    y1..y2 |> Enum.map(&{x, &1})
  end
  def coords_to_points({{x1, y}, {x2, y}}) do
    x1..x2 |> Enum.map(&{&1,y})
  end
  def coords_to_points({{x1, y1}, {x2, y2}}) do
    x1..x2 |> Enum.zip(y1..y2)
  end

  defp part1 do
    input()
    |> Enum.filter(&horizontal_or_vertical?/1)
    |> Enum.flat_map(&coords_to_points/1)
    |> Enum.frequencies
    |> Enum.filter(fn {_, freq} -> freq > 1 end)
    |> Enum.count
  end

  defp part2 do
    input()
    |> Enum.flat_map(&coords_to_points/1)
    |> Enum.frequencies
    |> Enum.filter(fn {_, freq} -> freq > 1 end)
    |> Enum.count
  end
end
