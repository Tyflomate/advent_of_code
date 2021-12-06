defmodule DayTemplate do
  @moduledoc false

  def input do
    {:ok, input} = File.read('./lib/X/input.txt')
    input
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  defp part1 do
    input()
    #|>
  end

  defp part2 do
    input()
    #|>
  end
end
