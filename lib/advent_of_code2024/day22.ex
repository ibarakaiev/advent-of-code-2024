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

  def solve(input, part: 2) do
    {sequences_to_price, consecutive_changes} =
      input
      |> parse()
      |> Enum.map_reduce([], fn initial, acc ->
        prices =
          1..2000
          |> Enum.reduce([initial], fn _, [head | _tail] = acc ->
            [evolve(head)] ++ acc
          end)
          |> Enum.reverse()
          |> Enum.map(&rem(&1, 10))

        prices_as_map = prices |> Enum.with_index() |> Map.new(fn {price, i} -> {i, price} end)

        consecutive_changes =
          prices
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [l, r] -> r - l end)
          |> Enum.chunk_every(4, 1, :discard)

        sequence_to_price =
          for {consecutive_change, i} <- consecutive_changes |> Enum.with_index(4) |> Enum.reverse(), reduce: %{} do
            acc ->
              Map.put(acc, consecutive_change, prices_as_map[i])
          end

        {sequence_to_price, consecutive_changes ++ acc}
      end)

    consecutive_changes
    |> MapSet.new()
    |> Enum.map(fn consecutive_change ->
      for sequence_to_price <- sequences_to_price, reduce: 0 do
        acc ->
          acc + (sequence_to_price[consecutive_change] || 0)
      end
    end)
    |> Enum.max()
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
