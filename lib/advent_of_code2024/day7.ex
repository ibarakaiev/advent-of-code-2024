defmodule AdventOfCode2024.Day7 do
  @moduledoc false
  def solve(input, part: part) do
    input
    |> parse()
    |> Enum.filter(fn {value, numbers} ->
      eval(List.first(numbers), Enum.drop(numbers, 1), value, allow_concat?: part == 2)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp eval(acc, [], value, _opts), do: acc == value

  defp eval(acc, [number | rest], value, [allow_concat?: allow_concat?] = opts) do
    eval(acc * number, rest, value, opts) or eval(acc + number, rest, value, opts) or
      if(allow_concat?, do: eval(concat(acc, number), rest, value, opts), else: false)
  end

  defp concat(a, b) do
    shift(a, b) + b
  end

  defp shift(a, 0), do: a
  defp shift(a, b), do: shift(a * 10, div(b, 10))

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [value, numbers] = String.split(row, ":", parts: 2, trim: true)

      {String.to_integer(value), numbers |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)}
    end)
  end
end
