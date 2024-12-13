defmodule AdventOfCode2024.Day13 do
  @moduledoc false
  def solve(input, part: part) do
    blocks = parse(input)

    blocks =
      case part do
        1 ->
          blocks

        2 ->
          Enum.map(blocks, fn %{prize: %{x: x, y: y}} = block ->
            Map.put(block, :prize, %{x: x + 10_000_000_000_000, y: y + 10_000_000_000_000})
          end)
      end

    blocks
    |> Enum.map(fn %{a: a, b: b, prize: prize} ->
      a_presses = div(b[:y] * prize[:x] - b[:x] * prize[:y], a[:x] * b[:y] - b[:x] * a[:y])
      b_presses = div(a[:x] * prize[:y] - a[:y] * prize[:x], a[:x] * b[:y] - b[:x] * a[:y])

      if a_presses * a[:x] + b_presses * b[:x] == prize[:x] and a_presses * a[:y] + b_presses * b[:y] == prize[:y] do
        a_presses * 3 + b_presses
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_block/1)
  end

  defp parse_block(block) do
    %{
      a: parse_line(block, ~r/Button A:\s*X(?:\+|=)(\d+),\s*Y(?:\+|=)(\d+)/),
      b: parse_line(block, ~r/Button B:\s*X(?:\+|=)(\d+),\s*Y(?:\+|=)(\d+)/),
      prize: parse_line(block, ~r/Prize:\s*X(?:\+|=)(\d+),\s*Y(?:\+|=)(\d+)/)
    }
  end

  defp parse_line(block, regex) do
    [_, x_str, y_str] = Regex.run(regex, block)

    %{x: String.to_integer(x_str), y: String.to_integer(y_str)}
  end
end
