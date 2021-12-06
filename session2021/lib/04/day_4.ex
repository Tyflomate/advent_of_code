defmodule Day4 do
  @moduledoc false

  def make_boards(raw_boards, board_lines) do
    raw_boards
    |> Enum.chunk_every(board_lines)
    |> Enum.map(&Enum.map(&1, fn line -> String.split(line, " ", trim: true) end))
  end

  def input(board_lines) do
    {:ok, input} = File.read('./lib/04/input.txt')
    [numbers | raw_boards] = input |> String.split("\n", trim: true)
    {
      String.split(numbers, ",", trim: true),
      raw_boards |> make_boards(board_lines)
    }
  end

  def solution do
    %{"part1" => part1(), "part2" => part2()}
  end

  def vertical_win?(board, numbers) do
    board
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> horizontal_win?(numbers)
  end

  def all_list_elements_in_another?(sub_list, list) do
    sub_list
    |> Enum.all?(&Enum.member?(list, &1))
  end

  def horizontal_win?(board, numbers) do
    board
    |> Enum.any?(&Day4.all_list_elements_in_another?(&1, numbers))
  end

  def board_win?(board, numbers) do
    vertical_win?(board, numbers) || horizontal_win?(board, numbers)
  end

  def handle_reduce(winning_boards, numbers, next_number, boards) do
    case winning_boards do
      [] -> {:cont, {[next_number | numbers], boards}}
      [board | []] -> {:halt, {numbers, board}}
    end
  end

  def check_boards_win(next_number, {current_numbers, boards}) do
    boards
    |> Enum.filter(&Day4.board_win?(&1, current_numbers))
    |> handle_reduce(current_numbers, next_number, boards)
  end

  def board_points(winning_numbers, board) do
    board
    |> List.flatten
    |> Enum.reject(&Enum.member?(winning_numbers, &1))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  defp part1 do
    {[first_number | numbers], boards} = Day4.input(5)
    {winning_numbers = [last_number | _], winning_board} = numbers |> Enum.reduce_while({[first_number], boards}, &check_boards_win/2)

    last_number
    |> String.to_integer
    |> Kernel.*(board_points(winning_numbers, winning_board))
  end

  def handle_reject_reduce(losing_boards, numbers, next_number) do
    case losing_boards do
      [board | []] ->
        if board_win?(board, numbers) do
          {:halt, {numbers, board}}
        else
          {:cont, {[next_number | numbers], losing_boards}}
        end
      _ -> {:cont, {[next_number | numbers], losing_boards}}
    end
  end

  def reject_wining_boards(next_number, {current_numbers, boards = [_ | []]}) do
    boards |> handle_reject_reduce(current_numbers, next_number)
  end
  def reject_wining_boards(next_number, {current_numbers, boards}) do
    boards
    |> Enum.reject(&Day4.board_win?(&1, current_numbers))
    |> handle_reject_reduce(current_numbers, next_number)
  end

  defp part2 do
    {[first_number | numbers], boards} = Day4.input(5)
    {winning_numbers = [last_number | _], winning_board} = numbers |> Enum.reduce_while({[first_number], boards}, &reject_wining_boards/2)

    last_number
    |> String.to_integer
    |> Kernel.*(board_points(winning_numbers, winning_board))
  end
end
