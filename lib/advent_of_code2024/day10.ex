defmodule AdventOfCode2024.Day10 do
  @moduledoc false
  def solve(input, part: part) do
    matrix = parse(input)

    matrix
    |> Enum.map(fn
      {{i, j}, 0} ->
        queue = :queue.in({i, j}, :queue.new())

        1
        |> Stream.iterate(&(&1 + 1))
        |> Enum.reduce_while({queue, MapSet.new(), 0}, fn _, {queue, visited, total_reachable} ->
          case :queue.out(queue) do
            {:empty, _} ->
              {:halt, total_reachable}

            {{:value, {i, j}}, queue} ->
              if part == 1 and MapSet.member?(visited, {i, j}) do
                {:cont, {queue, visited, total_reachable}}
              else
                visited = MapSet.put(visited, {i, j})

                case matrix[{i, j}] do
                  9 ->
                    {:cont, {queue, visited, total_reachable + 1}}

                  current_value ->
                    queue =
                      Enum.reduce([{1, 0}, {0, 1}, {-1, 0}, {0, -1}], queue, fn {d_i, d_j}, queue ->
                        case matrix[{i + d_i, j + d_j}] do
                          nil ->
                            queue

                          neighbor_value ->
                            if neighbor_value == current_value + 1 do
                              :queue.in({i + d_i, j + d_j}, queue)
                            else
                              queue
                            end
                        end
                      end)

                    {:cont, {queue, visited, total_reachable}}
                end
              end
          end
        end)

      {{_i, _j}, _v} ->
        0
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    matrix = input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    for {row, i} <- Enum.with_index(matrix), reduce: %{} do
      acc ->
        for {char, j} <- Enum.with_index(row), reduce: acc do
          acc ->
            Map.put(acc, {i, j}, String.to_integer(char))
        end
    end
  end
end
