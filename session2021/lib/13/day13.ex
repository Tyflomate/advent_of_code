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
  end

  def parse_instruction(instruction) do
    [direction | [pos]] = instruction
                          |> String.slice(-3..-1)
                          |> String.split("=", trim: true)
    {direction, String.to_integer(pos)}
  end

  def parse_instructions(instructions) do
    instructions |> Enum.map(&parse_instruction/1)
  end

  def input do
    {:ok, input} = File.read('./lib/13/input.txt')
    [positions | [instructions | _]] = input
                                       |> String.split("\n\n", trim: true)
                                       |> Enum.map(&String.split(&1, "\n", trim: true))
    {parse_positions(positions), parse_instructions(instructions)}
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  # Pour trouver la nouvelle position y, il faut prendre tous ceux avec un y > au pli, faire y-pli, et le nouveau y sera pli - diff
  # Same pour x
  defp part1 do
    #input()
    #|>
    nil
  end

  defp part2 do
    #input()
    #|>
    nil
  end
end
