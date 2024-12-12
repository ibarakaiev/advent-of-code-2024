defmodule AdventOfCode2024.Day12 do
  @moduledoc false
  def solve(input, part: part) do
    {map, n, m} = parse(input)

    map
    |> Enum.map_reduce(MapSet.new(), fn {{i, j}, char}, all_visited ->
      if MapSet.member?(all_visited, {i, j}) do
        {0, all_visited}
      else
        queue = :queue.in({i, j}, :queue.new())

        {same_chars, neighbors} =
          1
          |> Stream.iterate(&(&1 + 1))
          |> Enum.reduce_while({queue, MapSet.new(), MapSet.new()}, fn _, {queue, visited, neighbors} ->
            case :queue.out(queue) do
              {:empty, _} ->
                {:halt, {visited, neighbors}}

              {{:value, {i, j}}, queue} ->
                if MapSet.member?(visited, {i, j}) do
                  {:cont, {queue, visited, neighbors}}
                else
                  visited = MapSet.put(visited, {i, j})

                  {queue, neighbors} =
                    Enum.reduce([{1, 0}, {0, 1}, {-1, 0}, {0, -1}], {queue, neighbors}, fn {d_i, d_j},
                                                                                           {queue, neighbors} ->
                      case map[{i + d_i, j + d_j}] do
                        ^char ->
                          {:queue.in({i + d_i, j + d_j}, queue), neighbors}

                        _neighbor_value ->
                          {queue, MapSet.put(neighbors, {{i, j}, {d_i, d_j}})}
                      end
                    end)

                  {:cont, {queue, visited, neighbors}}
                end
            end
          end)

        perimeter =
          case part do
            1 ->
              MapSet.size(neighbors)

            2 ->
              horizontal_sides =
                Enum.reduce(neighbors, %{}, fn {{i, j}, {d_i, d_j}}, acc ->
                  case {d_i, d_j} do
                    {1, 0} -> Map.put(acc, {i + 1, j}, "v")
                    {-1, 0} -> Map.put(acc, {i, j}, "^")
                    _ -> acc
                  end
                end)

              horizontal_sides_count =
                0..n
                |> Enum.map(fn i ->
                  0..(m + 1)
                  |> Enum.chunk_every(2, 1, :discard)
                  |> Enum.reduce(0, fn [prev_j, curr_j], acc ->
                    if (horizontal_sides[{i, prev_j}] == "^" and horizontal_sides[{i, curr_j}] != "^") or
                         (horizontal_sides[{i, prev_j}] == "v" and horizontal_sides[{i, curr_j}] != "v") do
                      acc + 1
                    else
                      acc
                    end
                  end)
                end)
                |> Enum.sum()

              vertical_sides =
                Enum.reduce(neighbors, %{}, fn {{i, j}, {d_i, d_j}}, acc ->
                  case {d_i, d_j} do
                    {0, 1} -> Map.put(acc, {i, j + 1}, ">")
                    {0, -1} -> Map.put(acc, {i, j}, "<")
                    _ -> acc
                  end
                end)

              vertical_sides_count =
                0..m
                |> Enum.map(fn j ->
                  0..(n + 1)
                  |> Enum.chunk_every(2, 1, :discard)
                  |> Enum.reduce(0, fn [prev_i, curr_i], acc ->
                    if (vertical_sides[{prev_i, j}] == ">" and vertical_sides[{curr_i, j}] != ">") or
                         (vertical_sides[{prev_i, j}] == "<" and vertical_sides[{curr_i, j}] != "<") do
                      acc + 1
                    else
                      acc
                    end
                  end)
                end)
                |> Enum.sum()

              horizontal_sides_count + vertical_sides_count
          end

        {MapSet.size(same_chars) * perimeter, MapSet.union(all_visited, same_chars)}
      end
    end)
    |> then(fn {mapped, _acc} -> mapped end)
    |> Enum.sum()
  end

  defp parse(input) do
    matrix = input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    map =
      for {row, i} <- Enum.with_index(matrix), reduce: %{} do
        acc ->
          for {char, j} <- Enum.with_index(row), reduce: acc do
            acc ->
              Map.put(acc, {i, j}, char)
          end
      end

    {map, length(matrix), length(List.first(matrix))}
  end
end
