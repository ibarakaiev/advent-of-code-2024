defmodule AdventOfCode2024.Day3 do
  @moduledoc false
  def solve(input, part: part) do
    operations =
      ~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/
      |> Regex.scan(input)
      |> Enum.map(fn
        ["mul(" <> _rest, num1, num2] ->
          String.to_integer(num1) * String.to_integer(num2)

        ["do()" <> _rest] ->
          :do

        ["don't()" <> _rest] ->
          :dont
      end)

    total = operations |> Enum.filter(&is_number/1) |> Enum.sum()

    case part do
      1 ->
        total

      2 ->
        {subtract, _} =
          Enum.reduce(operations, {0, :do}, fn
            number, {acc, :dont} when is_number(number) ->
              {acc + number, :dont}

            number, {acc, :do} when is_number(number) ->
              {acc, :do}

            new_state, {acc, _state} ->
              {acc, new_state}
          end)

        total - subtract
    end
  end
end
