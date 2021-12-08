defmodule Day6 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/06/input.txt')
    input
    |> String.split("\n", trim: true)
    |> List.first
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  defp decrease_fish(0, [old_fishes | [new_fishes | []]]), do: [[6 | old_fishes], [8 | new_fishes]]
  defp decrease_fish(x, [old_fishes | [new_fishes | []]]), do: [[x - 1 | old_fishes], new_fishes]

  defp compute_next_fishes_step(fishes) do
    fishes
    |> List.foldl([[], []], &decrease_fish/2)
    |> List.flatten
  end

  defp evolve_fishes(fishes, 80), do: compute_next_fishes_step(fishes)
  defp evolve_fishes(fishes, step), do: evolve_fishes(compute_next_fishes_step(fishes), step + 1)

  defp part1 do
    input()
    |> evolve_fishes(1)
    |> Enum.count
  end

  def decrease_fish_v2({0, x}), do: {8, x}
  def decrease_fish_v2({x, y}), do: {x - 1, y}

  def compute_next_fishes_step_v2(fishes) do
    nb_mothers = Map.get(fishes, 0, 0)

    fishes
    |> Enum.map(&Day6.decrease_fish_v2(&1))
    |> Enum.into(%{})
    |> Map.update(6, nb_mothers, &(&1 + nb_mothers))
  end

  defp evolve_fishes_256(fishes, 256), do: compute_next_fishes_step_v2(fishes)
  defp evolve_fishes_256(fishes, step), do: evolve_fishes_256(compute_next_fishes_step_v2(fishes), step + 1)

  defp part2 do
    input()
    |> Enum.frequencies
    |> evolve_fishes_256(1)
    |> Map.values
    |> Enum.sum
  end
end
