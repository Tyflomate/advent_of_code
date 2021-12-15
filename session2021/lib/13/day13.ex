defmodule Day13 do
  @moduledoc false

  def parse_positions(positions) do
    positions
    |> Enum.map(
         fn x ->
           String.split(x, ",", trim: true)
           |> Enum.map(&String.to_integer/1)
           |> List.to_tuple
         end
       )
    |> MapSet.new
  end

  def parse_instruction(instruction) do
    [direction | [pos]] = instruction
                          |> String.replace_prefix("fold along ", "")
                          |> String.split("=", trim: true)
    {direction, String.to_integer(pos)}
  end

  def parse_instructions(instructions) do
    instructions
    |> Enum.map(&parse_instruction/1)
  end

  def input do
    {:ok, input} = File.read('./lib/13/input.txt')
    [positions | [instructions | _]] = input |> String.split("\n\n", trim: true) |> Enum.map(&String.split(&1, "\n", trim: true))
    {parse_positions(positions), parse_instructions(instructions)}
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def split_positions({"x", pos}, positions) do
    positions
    |> Enum.reduce(
         {[], []},
         fn curr = {x, _}, {kept, flipped} ->
           if x > pos, do: {kept, [curr | flipped]}, else: {[curr | kept], flipped}
         end
       )
  end

  def split_positions({"y", pos}, positions) do
    positions
    |> Enum.reduce(
         {[], []},
         fn curr = {_, y}, {kept, flipped} ->
           if y > pos, do: {kept, [curr | flipped]}, else: {[curr | kept], flipped}
         end
       )
  end

  def fold_position({"x", pos}, {x, y}), do: {pos - (x - pos), y}
  def fold_position({"y", pos}, {x,y}), do: {x, pos - (y - pos)}

  def apply_instruction(instruction, positions) do
    {kept, flipped} = split_positions(instruction, positions)

    flipped
    |> Enum.map(&fold_position(instruction, &1))
    |> Kernel.++(kept)
    |> MapSet.new
  end

  # Pour trouver la nouvelle position y, il faut prendre tous ceux avec un y > au pli, faire y-pli, et le nouveau y sera pli - diff
  # Same pour x
  defp part1 do
    {positions, [instruction | _]} = input()
    apply_instruction(instruction, positions)
    |> Enum.count
  end

  def fold_positions({positions, instructions}) do
    instructions
    |> Enum.reduce(positions, &apply_instruction/2)
  end

  def part2 do
    dots = fold_positions(input())
    {max_x, max_y} = Enum.max(dots)

    tab = for x <- 0..max_x do
      for y <- 0..max_y do
        if MapSet.member?(dots, {x,y}), do: "#", else: " "
      end
    end

    tab
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)
  end
end
