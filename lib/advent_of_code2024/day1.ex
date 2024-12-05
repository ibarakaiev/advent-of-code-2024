defmodule AdventOfCode2024.Day1 do
  @moduledoc false
  def solve(input, part: 1) do
    {left, right} = parse(input)

    left
    |> Enum.sort()
    |> Enum.zip(Enum.sort(right))
    |> Enum.reduce(0, fn {l, r}, acc ->
      acc + abs(r - l)
    end)
  end

  def solve(input, part: 2) do
    {left, right} = parse(input)

    frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn el, acc ->
      acc + el * Map.get(frequencies, el, 0)
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [left, right] = String.split(row, "   ")

      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.unzip()
  end
end
