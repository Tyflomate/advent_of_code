defmodule Day9 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/09/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string -> String.graphemes(string) |> Enum.map(&String.to_integer/1) end)
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def neighbors(max_x, 0, [_ | [curr_line | [next_line | []]]], max_x) do
    current = curr_line |> Enum.at(max_x)
    n1 = curr_line |> Enum.at(max_x - 1)
    n2 = next_line |> Enum.at(max_x)

    {current, [{n1, {max_x - 1, 0}}, {n2, {max_x, 1}}]}
  end
  def neighbors(max_x, y, [prev_line | [curr_line | [next_line | []]]], max_x) do
    current = curr_line |> Enum.at(max_x)
    n1 = prev_line |> Enum.at(max_x)
    n2 = curr_line |> Enum.at(max_x - 1)
    n3 = next_line |> Enum.at(max_x)

    {current, [{n1, {max_x, y - 1}}, {n2, {max_x - 1, y}}, {n3, {max_x, y + 1}}]}
  end
  def neighbors(0, 0, [_ | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(0)
    n1 = curr_line |> Enum.at(1)
    n2 = next_line |> Enum.at(0)

    {current, [{n1, {1, 0}}, {n2, {0, 1}}]}
  end
  def neighbors(x, 0, [_ | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(x)
    n1 = curr_line |> Enum.at(x - 1)
    n2 = curr_line |> Enum.at(x + 1)
    n3 = next_line |> Enum.at(x)

    {current, [{n1, {x - 1, 0}}, {n2, {x + 1, 0}}, {n3, {x, 1}}]}
  end
  def neighbors(0, y, [prev_line | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(0)
    n1 = prev_line |> Enum.at(0)
    n2 = curr_line |> Enum.at(1)
    n3 = next_line |> Enum.at(0)

    {current, [{n1, {0, y - 1}}, {n2, {1, y}}, {n3, {0, y + 1}}]}
  end
  def neighbors(0, y, [prev_line | [curr_line | []]], _) do
    current = curr_line |> Enum.at(0)
    n1 = prev_line |> Enum.at(0)
    n2 = curr_line |> Enum.at(1)

    {current, [{n1, {0, y - 1}}, {n2, {1, y}}]}
  end
  def neighbors(max_x, y, [prev_line | [curr_line | []]], max_x) do
    current = curr_line |> Enum.at(max_x)
    n1 = prev_line |> Enum.at(max_x)
    n2 = curr_line |> Enum.at(max_x - 1)

    {current, [{n1, {max_x, y - 1}}, {n2, {max_x - 1, y}}]}
  end
  def neighbors(x, y, [prev_line | [curr_line | []]], _) do
    current = curr_line |> Enum.at(x)
    n1 = prev_line |> Enum.at(x)
    n2 = curr_line |> Enum.at(x - 1)
    n3 = curr_line |> Enum.at(x + 1)

    {current, [{n1, {x, y - 1}}, {n2, {x - 1, y}}, {n3, {x + 1, y}}]}
  end
  def neighbors(x, y, [prev_line | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(x)
    n1 = prev_line |> Enum.at(x)
    n2 = curr_line |> Enum.at(x - 1)
    n3 = curr_line |> Enum.at(x + 1)
    n4 = next_line |> Enum.at(x)

    {current, [{n1, {x, y - 1}}, {n2, {x - 1, y}}, {n3, {x + 1, y}}, {n4, {x, y + 1}}]}
  end

  def low_point?(x, y, low_points, curr_triplets, max_x) do
    {current, neighbors} = neighbors(x, y, curr_triplets, max_x)
    if Enum.all?(neighbors, fn {ele, _} -> ele > current end), do: [{current, {x, y}} | low_points], else: low_points
  end

  def filter_low_points(curr_triplet, {y, low_points}, max_x) do
    new_points = 0..max_x |> Enum.reduce([], &low_point?(&1, y, &2, curr_triplet, max_x))
    {y + 1, new_points ++ low_points}
  end

  def low_points(list = [head | _]) do
    max_x = head |> Enum.count |> Kernel.-(1)

    list
    |> List.insert_at(0, [])
    |> Enum.chunk_every(3, 1, [])
    |> List.foldl({0, []}, &filter_low_points(&1, &2, max_x))
    |> elem(1)
  end

  defp part1 do
    lp = input() |> low_points |> Enum.map(&elem(&1, 0))

    Enum.sum(lp) + Enum.count(lp)
  end

  def get_neighbors_basins([], _, _, _), do: []
  def get_neighbors_basins(neighbors, list, max_x, max_y) do
    neighbors
    |> Enum.flat_map(&get_basin(&1, list, max_x, max_y))
  end

  def triplet(list, 0, _), do: [[] | [list |> Enum.at(0) | [list |> Enum.at(1)]]]
  def triplet(list, max_y, max_y), do: [list |> Enum.at(max_y - 1) | [list |> List.last | []]]
  def triplet(list, y, _), do: [list |> Enum.at(y - 1) | [list |> Enum.at(y) | [list |> Enum.at(y + 1)]]]

  def basin_neighbors({ele, {x, y}}, list, max_x, max_y) do
    neighbors(x, y, triplet(list, y, max_y), max_x)
    |> elem(1)
    |> Enum.filter(fn {n, _} -> ele + 1 == n && n != 9 end)
  end

  def get_basin(ele, list, max_x, max_y) do
    [ele] ++ get_neighbors_basins(basin_neighbors(ele, list, max_x, max_y), list, max_x, max_y)
  end

  def get_basins(ele, list, max_x, max_y) do
    get_basin(ele, list, max_x, max_y)
  end

  def intersection?(basin, previous_basin) do
    Enum.any?(basin, fn x -> x in previous_basin end)
  end

  def merge_basins(basin, previous_basins) do
    case Enum.filter(previous_basins, &intersection?(basin, &1)) do
      [] -> [basin | previous_basins]
      extras ->
        IO.puts("intersection!")
        loners = previous_basins -- extras
        reunited_basins = extras |> Enum.map(&(basin ++ &1))
        [reunited_basins | loners]
    end
  end

  def basins_size(list = [head | _]) do
    max_x = head |> Enum.count |> Kernel.-(1)
    max_y = list |> Enum.count |> Kernel.-(1)

    list
    |> low_points
    |> Enum.map(&get_basins(&1, list, max_x, max_y))
    |> Enum.reduce([], &merge_basins/2)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
  end

  defp part2 do
    input()
    |> basins_size
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end
end
