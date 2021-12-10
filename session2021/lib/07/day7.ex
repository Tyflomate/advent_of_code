defmodule Day7 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/07/input.txt')
    input
    |> String.split("\n", trim: true)
    |> List.first
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def range_from_tuple({x,y}), do: x..y

  def calculate_fuel(x, pos) do
    pos
    |> Enum.map(&(abs(&1 - x)))
    |> Enum.sum
  end

  def handle_fold(res, old_acc = {min, _}) when res >= min, do: old_acc
  def handle_fold(res, {min, list}) when res < min, do: {res, list}

  def calculate_fuels(curr, acc = {_, list}) do
    curr
    |> calculate_fuel(list)
    |> handle_fold(acc)
  end

  def calculate_min_fuel(list) do
    [head | range] = list |> Enum.min_max |> range_from_tuple |> Enum.to_list
    first_fuel = calculate_fuel(head, list)

    range
    |> List.foldl({first_fuel, list}, &Day7.calculate_fuels/2)
    |> elem(0)
  end

  defp part1 do
    input() |> calculate_min_fuel
  end

  def sum_from_a_to_n(n), do: n * (n + 1) / 2

  def calculate_fuel_v2(x, pos) do
    pos
    |> Enum.map(fn value -> abs(value - x) |> sum_from_a_to_n end)
    |> Enum.sum
  end

  def calculate_fuels_v2(curr, acc = {_, list}) do
    curr
    |> calculate_fuel_v2(list)
    |> handle_fold(acc)
  end

  def calculate_min_fuel_v2(list) do
    [head | range] = list |> Enum.min_max |> range_from_tuple |> Enum.to_list
    first_fuel = calculate_fuel_v2(head, list)

    range
    |> List.foldl({first_fuel, list}, &Day7.calculate_fuels_v2/2)
    |> elem(0)
  end

  defp part2 do
    input() |> calculate_min_fuel_v2
  end
end
