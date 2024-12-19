defmodule AdventOfCode2024.Day19 do
  @moduledoc false
  def solve(input, part: 1) do
    {patterns, designs} = parse(input)

    Enum.count(designs, &possible?(&1, patterns))
  end

  defp possible?("", _), do: true

  defp possible?(design, patterns) do
    Enum.any?(patterns, fn pattern ->
      if String.starts_with?(design, pattern) do
        ^pattern <> rest = design
        possible?(rest, patterns)
      end
    end)
  end

  defp parse(input) do
    [available_patterns, designs] = String.split(input, "\n\n", parts: 2, trim: true)

    {String.split(available_patterns, ", ", trim: true), String.split(designs, "\n", trim: true)}
  end
end
