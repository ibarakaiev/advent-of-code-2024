defmodule AdventOfCode2024.Day15 do
  @moduledoc false
  def solve(input, part: part) do
    {map, instructions} = parse(input, part: part)

    {{start_i, start_j}, "@"} = Enum.find(map, fn {_k, v} -> v == "@" end)

    instructions
    |> Enum.reduce({map, {start_i, start_j}}, fn instruction, {map, {i, j}} ->
      {d_i, d_j} =
        case instruction do
          "^" -> {-1, 0}
          ">" -> {0, 1}
          "v" -> {1, 0}
          "<" -> {0, -1}
        end

      case map[{i + d_i, j + d_j}] do
        "." ->
          {map |> Map.put({i, j}, ".") |> Map.put({i + d_i, j + d_j}, "@"), {i + d_i, j + d_j}}

        "#" ->
          {map, {i, j}}

        char when char == "O" ->
          nearest_empty =
            1
            |> Stream.iterate(&(&1 + 1))
            |> Enum.reduce_while(nil, fn k, _ ->
              case map[{i + k * d_i, j + k * d_j}] do
                "O" -> {:cont, nil}
                "[" -> {:cont, nil}
                "]" -> {:cont, nil}
                "#" -> {:halt, nil}
                "." -> {:halt, k}
              end
            end)

          case nearest_empty do
            nil ->
              {map, {i, j}}

            k ->
              updated_map =
                map
                |> Map.put({i, j}, ".")
                |> Map.put({i + d_i, j + d_j}, "@")
                |> Map.put({i + k * d_i, j + k * d_j}, "O")

              {updated_map, {i + d_i, j + d_j}}
          end

        char when char == "[" or char == "]" ->
          case instruction do
            instruction when instruction == "<" or instruction == ">" ->
              nearest_empty =
                1
                |> Stream.iterate(&(&1 + 1))
                |> Enum.reduce_while(nil, fn k, _ ->
                  case map[{i + k * d_i, j + k * d_j}] do
                    "O" -> {:cont, nil}
                    "[" -> {:cont, nil}
                    "]" -> {:cont, nil}
                    "#" -> {:halt, nil}
                    "." -> {:halt, k}
                  end
                end)

              case nearest_empty do
                nil ->
                  {map, {i, j}}

                k ->
                  updated_map =
                    k..1//-1
                    |> Enum.reduce(map, fn k, map ->
                      Map.put(map, {i + k * d_i, j + k * d_j}, map[{i + (k - 1) * d_i, j + (k - 1) * d_j}])
                    end)
                    |> Map.put({i, j}, ".")

                  {updated_map, {i + d_i, j + d_j}}
              end

            instruction when instruction == "^" or instruction == "v" ->
              connected_boxes =
                1
                |> Stream.iterate(&(&1 + 1))
                |> Enum.reduce_while(%{0 => MapSet.new([{j, j}])}, fn k, acc ->
                  new_neighbors =
                    acc[k - 1]
                    |> Enum.flat_map(fn {left, right} ->
                      left_neighbor =
                        case map[{i + k * d_i, left}] do
                          "]" ->
                            {left - 1, left}

                          "[" ->
                            {left, left + 1}

                          _ ->
                            nil
                        end

                      right_neighbor =
                        case map[{i + k * d_i, right}] do
                          "[" ->
                            {right, right + 1}

                          "]" ->
                            {right - 1, right}

                          _ ->
                            nil
                        end

                      [left_neighbor, right_neighbor]
                    end)
                    |> Enum.reject(&is_nil(&1))
                    |> MapSet.new()

                  if MapSet.size(new_neighbors) == 0 do
                    {:halt, acc}
                  else
                    {:cont, Map.put(acc, k, new_neighbors)}
                  end
                end)

              can_move? =
                Enum.reduce_while(connected_boxes, true, fn {k, list}, _acc ->
                  can_row_move? =
                    Enum.reduce_while(list, true, fn {left, right}, _acc ->
                      if map[{i + (k + 1) * d_i, left}] != "#" and map[{i + (k + 1) * d_i, right}] != "#" do
                        {:cont, true}
                      else
                        {:halt, false}
                      end
                    end)

                  if can_row_move? do
                    {:cont, true}
                  else
                    {:halt, false}
                  end
                end)

              if can_move? do
                max_k = Enum.max(Map.keys(connected_boxes))

                map =
                  Enum.reduce(max_k..0//-1, map, fn k, map ->
                    for {left, right} <- connected_boxes[k], reduce: map do
                      map ->
                        map
                        |> Map.put({i + (k + 1) * d_i, left}, map[{i + k * d_i, left}])
                        |> Map.put({i + (k + 1) * d_i, right}, map[{i + k * d_i, right}])
                        |> Map.put({i + k * d_i, left}, ".")
                        |> Map.put({i + k * d_i, right}, ".")
                    end
                  end)

                {map, {i + d_i, j + d_j}}
              else
                {map, {i, j}}
              end
          end
      end
    end)
    |> then(fn {map, _coordinates} -> map end)
    |> Enum.reduce(0, fn {{i, j}, v}, acc ->
      case v do
        "O" -> acc + i * 100 + j
        "[" -> acc + i * 100 + j
        _ -> acc
      end
    end)
  end

  defp parse(input, part: part) do
    [grid, instructions] = String.split(input, "\n\n", trim: true, parts: 2)

    matrix = grid |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    matrix =
      case part do
        1 ->
          matrix

        2 ->
          Enum.map(matrix, fn row ->
            Enum.flat_map(row, fn char ->
              case char do
                "#" -> ["#", "#"]
                "O" -> ["[", "]"]
                "." -> [".", "."]
                "@" -> ["@", "."]
              end
            end)
          end)
      end

    map =
      for {row, i} <- Enum.with_index(matrix), reduce: %{} do
        acc ->
          for {char, j} <- Enum.with_index(row), reduce: acc do
            acc ->
              Map.put(acc, {i, j}, char)
          end
      end

    instructions = instructions |> String.split("\n", trim: true) |> Enum.join("") |> String.graphemes()

    {map, instructions}
  end
end
