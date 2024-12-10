defmodule AdventOfCode2024.Day9 do
  @moduledoc false
  def solve(input, part: 1) do
    disk_map = input |> String.trim() |> String.graphemes() |> Enum.map(&String.to_integer/1)

    expanded_disk_map =
      disk_map
      |> Enum.chunk_every(2, 2)
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {[left, right], i} -> List.duplicate(Integer.to_string(i), left) ++ List.duplicate(".", right)
        {[element], i} -> List.duplicate(Integer.to_string(i), element)
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {char, i}, acc -> Map.put(acc, i, char) end)

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({expanded_disk_map, 0, length(Map.keys(expanded_disk_map)) - 1}, fn _, {acc, i, j} ->
      if j <= i do
        {:halt, acc}
      else
        if acc[i] == "." do
          if acc[j] == "." do
            {:cont, {acc, i, j - 1}}
          else
            acc = acc |> Map.put(i, acc[j]) |> Map.put(j, ".")

            {:cont, {acc, i + 1, j - 1}}
          end
        else
          {:cont, {acc, i + 1, j}}
        end
      end
    end)
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> Stream.filter(fn {_k, v} -> v != "." end)
    |> Stream.map(fn {_k, v} -> String.to_integer(v) end)
    |> Stream.with_index()
    |> Stream.map(fn {v, i} -> v * i end)
    |> Enum.sum()
  end

  def solve(input, part: 2) do
    disk_map = input |> String.trim() |> String.graphemes() |> Enum.map(&String.to_integer/1)

    expanded_disk_map =
      disk_map
      |> Stream.chunk_every(2, 2)
      |> Stream.with_index()
      |> Enum.map(fn
        {[left, right], i} ->
          [
            i |> Integer.to_string() |> List.duplicate(left) |> List.to_tuple(),
            "." |> List.duplicate(right) |> List.to_tuple()
          ]

        {[element], i} ->
          i |> Integer.to_string() |> List.duplicate(element) |> List.to_tuple()
      end)
      |> List.flatten()
      |> Stream.reject(&(&1 == {}))
      |> Stream.map(fn tuple ->
        {elem(tuple, 0), tuple_size(tuple)}
      end)
      |> Stream.with_index()
      |> Enum.reduce(%{}, fn {char, i}, acc -> Map.put(acc, i, char) end)

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({expanded_disk_map, 0, length(Map.keys(expanded_disk_map)) - 1}, fn _, {acc, i, j} ->
      if j == 0 do
        {:halt, acc}
      else
        if i >= j do
          {:cont, {acc, 0, j - 1}}
        else
          {right_char, right_size} = acc[j]

          if right_char == "." do
            {:cont, {acc, 0, j - 1}}
          else
            {left_char, left_size} = acc[i]

            if left_char == "." do
              cond do
                left_size < right_size ->
                  {:cont, {acc, i + 1, j}}

                left_size == right_size ->
                  acc = acc |> Map.put(i, {right_char, right_size}) |> Map.put(j, {".", right_size})

                  {:cont, {reindex(acc), 0, j - 1}}

                left_size > right_size ->
                  # partitions left into two
                  acc =
                    acc
                    |> Map.put(i, {right_char, right_size})
                    |> Map.put(i + 0.5, {".", left_size - right_size})
                    |> Map.put(j, {".", right_size})

                  {:cont, {reindex(acc), 0, j}}
              end
            else
              {:cont, {acc, i + 1, j}}
            end
          end
        end
      end
    end)
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> Enum.flat_map(fn {_k, {char, size}} -> List.duplicate(char, size) end)
    |> Enum.with_index()
    |> Enum.map(fn
      {v, _i} when v == "." -> 0
      {v, i} -> i * String.to_integer(v)
    end)
    |> Enum.sum()
  end

  defp reindex(map) do
    map
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.with_index()
    |> Map.new(fn {v, i} -> {i, v} end)
  end
end
