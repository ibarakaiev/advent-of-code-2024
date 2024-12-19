defmodule AdventOfCode2024.Day19 do
  @moduledoc false

  use Memoize

  def solve(input, part: part) do
    {patterns, designs} = parse(input)

    case part do
      1 -> Enum.count(designs, &possible?(&1, patterns))
      2 -> designs |> Enum.map(&total(&1, patterns)) |> Enum.sum()
    end
  end

  defmemo(possible?("", _), do: true)

  defmemo possible?(design, patterns) do
    Enum.any?(patterns, fn pattern ->
      if String.starts_with?(design, pattern) do
        ^pattern <> rest = design
        possible?(rest, patterns)
      end
    end)
  end

  defmemo(total("", _), do: 1)

  defmemo total(design, patterns) do
    patterns
    |> Enum.map(fn pattern ->
      if String.starts_with?(design, pattern) do
        ^pattern <> rest = design
        total(rest, patterns)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    [available_patterns, designs] = String.split(input, "\n\n", parts: 2, trim: true)

    {String.split(available_patterns, ", ", trim: true), String.split(designs, "\n", trim: true)}
  end
end
