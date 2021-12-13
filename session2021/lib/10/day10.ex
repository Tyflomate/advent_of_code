defmodule Day10 do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/10/input.txt')
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def opener?(chunk_part), do: chunk_part in ["(", "{", "[", "<"]

  def check_chunk_line(")", ["(" | previous_openers]), do: {:cont, previous_openers}
  def check_chunk_line("]", ["[" | previous_openers]), do: {:cont, previous_openers}
  def check_chunk_line("}", ["{" | previous_openers]), do: {:cont, previous_openers}
  def check_chunk_line(">", ["<" | previous_openers]), do: {:cont, previous_openers}
  def check_chunk_line(chunk_part, openers) do
    if opener?(chunk_part), do: {:cont, [chunk_part | openers]}, else: {:halt, chunk_part}
  end

  # if we have a list, it means that we did not stopped
  def add_chunk_part_if_error(line_result, acc) when is_list(line_result), do: acc
  # if we dont, it means that we have the error char, so we add it to the list
  def add_chunk_part_if_error(line_result, misplaced_chunk_parts), do: [line_result | misplaced_chunk_parts]

  def find_wrong_chunk_parts([head | chunk_list], acc) do
    chunk_list
    |> Enum.reduce_while([head], &check_chunk_line/2)
    |> add_chunk_part_if_error(acc)
  end

  def chunk_part_points(")"), do: 3
  def chunk_part_points("]"), do: 57
  def chunk_part_points("}"), do: 1197
  def chunk_part_points(">"), do: 25137
  def chunk_part_points(_), do: 0

  def transform_to_points({chunk_part, occurrences}), do: chunk_part_points(chunk_part) * occurrences

  defp part1 do
    input()
    |> Enum.reduce([], &find_wrong_chunk_parts/2)
    |> Enum.frequencies
    |> Enum.map(&transform_to_points/1)
    |> Enum.sum
  end

  def opener_completion_point("(", acc), do: acc * 5 + 1
  def opener_completion_point("[", acc), do: acc * 5 + 2
  def opener_completion_point("{", acc), do: acc * 5 + 3
  def opener_completion_point("<", acc), do: acc * 5 + 4

  def get_completion_points(openers) do
    openers
    |> Enum.reduce(0, &opener_completion_point/2)
  end

  # if we have a list, it means that we did not stopped, so we need to complete the list
  def add_line_completion(openers, acc) when is_list(openers), do: [get_completion_points(openers) | acc]
  # if we dont, it means that we have the error char, so we just return the acc
  def add_line_completion(_, acc), do: acc

  def completion_points_of_unfinished_chunk_parts([head | chunk_list], acc) do
    chunk_list
    |> Enum.reduce_while([head], &check_chunk_line/2)
    |> add_line_completion(acc)
  end

  defp part2 do
    completion_points = input() |> Enum.reduce([], &completion_points_of_unfinished_chunk_parts/2) |> Enum.sort
    Enum.at(completion_points, div(length(completion_points) - 1, 2) )
  end
end
