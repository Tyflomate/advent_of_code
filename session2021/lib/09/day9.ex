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

    {current, [n1, n2]}
  end
  def neighbors(max_x, _, [prev_line | [curr_line | [next_line | []]]], max_x) do
    current = curr_line |> Enum.at(max_x)
    n1 = prev_line |> Enum.at(max_x)
    n2 = curr_line |> Enum.at(max_x - 1)
    n3 = next_line |> Enum.at(max_x)

    {current, [n1, n2, n3]}
  end
  def neighbors(0, 0, [_ | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(0)
    n1 = curr_line |> Enum.at(1)
    n2 = next_line |> Enum.at(0)

    {current, [n1, n2]}
  end
  def neighbors(x, 0, [_ | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(x)
    n1 = curr_line |> Enum.at(x - 1)
    n2 = curr_line |> Enum.at(x + 1)
    n3 = next_line |> Enum.at(x)

    {current, [n1, n2, n3]}
  end
  def neighbors(0, _, [prev_line | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(0)
    n1 = prev_line |> Enum.at(0)
    n2 = curr_line |> Enum.at(1)
    n3 = next_line |> Enum.at(0)

    {current, [n1, n2, n3]}
  end
  def neighbors(x, _, [prev_line | [curr_line | [next_line | []]]], _) do
    current = curr_line |> Enum.at(x)
    n1 = prev_line |> Enum.at(x)
    n2 = curr_line |> Enum.at(x - 1)
    n3 = curr_line |> Enum.at(x + 1)
    n4 = next_line |> Enum.at(x)

    {current, [n1, n2, n3, n4]}
  end
  def neighbors(0, _, [prev_line | [curr_line | []]], _) do
    current = curr_line |> Enum.at(0)
    n1 = prev_line |> Enum.at(0)
    n2 = curr_line |> Enum.at(1)

    {current, [n1, n2]}
  end
  def neighbors(max_x, _, [prev_line | [curr_line | []]], max_x) do
    current = curr_line |> Enum.at(max_x)
    n1 = prev_line |> Enum.at(max_x)
    n2 = curr_line |> Enum.at(max_x - 1)

    {current, [n1, n2]}
  end
  def neighbors(x, _, [prev_line | [curr_line | []]], _) do
    current = curr_line |> Enum.at(x)
    n1 = prev_line |> Enum.at(x)
    n2 = curr_line |> Enum.at(x - 1)
    n3 = curr_line |> Enum.at(x + 1)

    {current, [n1, n2, n3]}
  end

  def low_point?(x, y, low_points, curr_triplets, max_x) do
    {current, neighbors} = neighbors(x, y, curr_triplets, max_x)
    if Enum.all?(neighbors, fn ele -> ele > current end), do: [current | low_points], else: low_points
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
    lp = input() |> low_points

    Enum.sum(lp) + Enum.count(lp)
  end

  defp part2 do
    input()
    |>
  end
end
