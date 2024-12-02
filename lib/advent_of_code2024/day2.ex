defmodule AdventOfCode2024.Day2 do
  def solve(input, part: 1) do
    reports = parse(input)

    Enum.count(reports, &safe?/1)
  end

  def solve(input, part: 2) do
    reports = parse(input)

    Enum.count(reports, fn report ->
      safe?(report) or
        0..(length(report) - 1)
        |> Stream.map(fn i ->
          Enum.slice(report, 0, i) ++ Enum.slice(report, i + 1, length(report) - (i + 1))
        end)
        |> Enum.any?(&safe?/1)
    end)
  end

  defp safe?(report) do
    differences =
      report
      |> Stream.chunk_every(2, 1, :discard)
      |> Enum.map(fn [left, right] -> left - right end)

    Enum.all?(differences, &(&1 <= 3 and &1 >= 1)) or
      Enum.all?(differences, &(&1 >= -3 and &1 <= -1))
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
