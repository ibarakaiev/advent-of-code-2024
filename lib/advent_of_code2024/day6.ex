defmodule AdventOfCode2024.Day6 do
  @moduledoc false
  def solve(input, part: part) do
    matrix = parse(input)

    {{start_y, start_x}, "^"} = Enum.find(matrix, &match?({_, "^"}, &1))

    {updated_matrix, visited} = traverse(matrix, {start_y, start_x})

    case part do
      1 ->
        1 + Enum.count(updated_matrix, &match?({_, "X"}, &1))

      2 ->
        visited
        |> Enum.filter(&(&1 != {start_y, start_x}))
        |> Enum.reduce(0, fn {obstacle_y, obstacle_x}, acc ->
          modified_matrix = Map.put(matrix, {obstacle_y, obstacle_x}, "O")

          case traverse(modified_matrix, {start_y, start_x}) do
            :loop -> acc + 1
            _ -> acc
          end
        end)
    end
  end

  defp traverse(matrix, {start_y, start_x}) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({matrix, {start_y, start_x}, MapSet.new()}, fn _, {matrix, {y, x}, visited} ->
      {{d_y, d_x}, current, rotated} =
        case matrix[{y, x}] do
          "^" -> {{-1, 0}, "^", ">"}
          ">" -> {{0, 1}, ">", "v"}
          "v" -> {{1, 0}, "v", "<"}
          "<" -> {{0, -1}, "<", "^"}
        end

      if MapSet.member?(visited, {{y, x}, current}) do
        {:halt, :loop}
      else
        updated_visited = MapSet.put(visited, {{y, x}, current})

        case matrix[{y + d_y, x + d_x}] do
          char when char == "#" or char == "O" ->
            updated_matrix = Map.put(matrix, {y, x}, rotated)

            {:cont, {updated_matrix, {y, x}, updated_visited}}

          char when char == "." or char == "X" ->
            updated_matrix = matrix |> Map.put({y, x}, "X") |> Map.put({y + d_y, x + d_x}, current)

            {:cont, {updated_matrix, {y + d_y, x + d_x}, updated_visited}}

          nil ->
            {:halt, {matrix, MapSet.new(updated_visited, &elem(&1, 0))}}
        end
      end
    end)
  end

  defp parse(input) do
    matrix = input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    for {row, i} <- Enum.with_index(matrix), reduce: %{} do
      acc ->
        for {char, j} <- Enum.with_index(row), reduce: acc do
          acc ->
            Map.put(acc, {i, j}, char)
        end
    end
  end
end
