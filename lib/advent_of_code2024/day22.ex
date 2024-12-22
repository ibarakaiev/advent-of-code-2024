defmodule AdventOfCode2024.Day22 do
  @moduledoc false
  import Bitwise

  def solve(input, part: 1) do
    input
    |> parse()
    |> Enum.map(fn initial ->
      Enum.reduce(1..2000, initial, fn _, initial ->
        evolve(initial)
      end)
    end)
    |> Enum.sum()
  end

  def evolve(secret_number) do
    secret_number = rem(bxor(secret_number * 64, secret_number), 16_777_216)
    secret_number = rem(bxor(div(secret_number, 32), secret_number), 16_777_216)
    secret_number = rem(bxor(secret_number * 2048, secret_number), 16_777_216)

    secret_number
  end

  defp parse(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
