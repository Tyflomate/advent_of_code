defmodule Day12 do
  @moduledoc false

  def upcase?(string), do: string == String.upcase(string)

  def make_paths(path = {left, right}), do: [path | [{right, left}]]

  def input do
    {:ok, input} = File.read('./lib/12/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
         &String.split(&1, "-", trim: true)
          |> List.to_tuple
       )
    |> Enum.flat_map(&make_paths/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def filter_available_paths(available_paths, start_point) do
    if upcase?(start_point) do
      available_paths
    else
      available_paths
      |> Enum.map(fn {k, v} -> { k, v |> List.delete(start_point) } end)
      |> Enum.into(%{})
    end
  end

  def handle_destinations([], _, _, _), do: []
  def handle_destinations(destinations, available_paths, current_path = [start_point | _]) do
    filtered_paths = filter_available_paths(available_paths, start_point)
    destinations
    |> Enum.flat_map(&get_paths(filtered_paths, &1, current_path))
  end

  def get_paths(_, "end", path), do: [["end" | path]]
  def get_paths(available_paths, start_point, current_path) do
    available_paths
    |> Map.get(start_point, [])
    |> handle_destinations(available_paths, [start_point | current_path])
  end

  defp part1 do
    input()
    |> get_paths("start", [])
    |> Enum.count
  end

  def small_cave_visited_twice?(list) do
    list
    |> Enum.filter(fn x -> !upcase?(x) end)
    |> Enum.frequencies
    |> Enum.any?(fn {_, x} -> x == 2 end)
  end

  def second_visit?(list, point), do: Enum.member?(list, point)

  def delete_point_from_paths(point, available_paths) do
    available_paths
    |> Enum.map(fn {k, v} -> { k, v |> List.delete(point) } end)
    |> Enum.into(%{})
  end

  def update_available_paths(available_paths, ["start" | _]), do: delete_point_from_paths("start", available_paths)
  def update_available_paths(available_paths, [start_point | previous_points]) do
    if upcase?(start_point) do
      available_paths
    else
      if small_cave_visited_twice?(previous_points) do
        delete_point_from_paths(start_point, available_paths)
      else
        if second_visit?(previous_points, start_point) do
          previous_points
          |> Enum.filter(fn x -> !upcase?(x) end)
          |> Enum.reduce(available_paths, &delete_point_from_paths/2)
        else
          available_paths
        end
      end
    end
  end

  def handle_destinations_2([], _, _), do: []
  def handle_destinations_2(destinations, available_paths, current_path) do
    destinations
    |> Enum.flat_map(&get_paths_2(available_paths, &1, current_path))
  end

  def get_paths_2(_, "end", path), do: [["end" | path]]
  def get_paths_2(available_paths, start_point, current_path) do
    new_path = [start_point | current_path]
    filtered_paths = update_available_paths(available_paths, new_path)
    filtered_paths |> Map.get(start_point, [])
    |> handle_destinations_2(filtered_paths, new_path)
  end

  defp part2 do
    input()
    |> get_paths_2("start", [])
    |> Enum.count
  end
end
