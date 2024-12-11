defmodule AdventOfCode2024.Day11 do
  @moduledoc false
  def solve(input, part: part) do
    map = input |> String.split(" ", trim: true) |> Map.new(&{String.to_integer(&1), 1})

    iterations =
      case part do
        1 -> 25
        2 -> 75
      end

    1..iterations
    |> Enum.reduce(map, fn _, map ->
      Enum.reduce(map, Map.new(), fn {number, frequency}, acc ->
        cond do
          number == 0 ->
            Map.put(acc, 1, (acc[1] || 0) + frequency)

          even?(number) ->
            {left, right} = split(number)

            acc = Map.put(acc, left, (acc[left] || 0) + frequency)
            Map.put(acc, right, (acc[right] || 0) + frequency)

          true ->
            new_number = number * 2024

            Map.put(acc, new_number, (acc[new_number] || 0) + frequency)
        end
      end)
    end)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.sum()
  end

  defp even?(number) do
    digits = Integer.digits(number)

    rem(length(digits), 2) == 0
  end

  def split(number) do
    digits = Integer.digits(number)

    {left, right} = Enum.split(digits, div(length(digits), 2))

    {Integer.undigits(left), Integer.undigits(right)}
  end
end
