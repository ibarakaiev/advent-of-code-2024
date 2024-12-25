defmodule AdventOfCode2024.Day25 do
  @moduledoc false
  def solve(input, part: 1) do
    {locks, keys, n} = parse(input)

    for_result =
      for lock <- locks, key <- keys do
        lock
        |> Enum.zip(key)
        |> Enum.reduce_while(true, fn {lock_el, key_el}, acc ->
          if lock_el + key_el <= n do
            {:cont, acc}
          else
            {:halt, false}
          end
        end)
      end

    Enum.count(for_result, & &1)
  end

  defp parse(input) do
    blocks = String.split(input, "\n\n", trim: true)

    locks = Enum.filter(blocks, &String.starts_with?(&1, "#"))
    keys = Enum.filter(blocks, &String.starts_with?(&1, "."))

    {Enum.map(locks, &to_height/1), Enum.map(keys, &to_height/1),
     blocks |> List.first() |> String.split("\n") |> length()}
  end

  defp to_height(block) do
    rows = String.split(block, "\n", trim: true)

    m = String.length(List.first(rows))

    for j <- 0..(m - 1) do
      for row <- rows, reduce: 0 do
        acc ->
          if String.at(row, j) == "#" do
            acc + 1
          else
            acc
          end
      end
    end
  end
end
