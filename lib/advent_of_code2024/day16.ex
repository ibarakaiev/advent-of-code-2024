defmodule AdventOfCode2024.Day16 do
  @moduledoc false

  def solve(input, part: part) do
    {maze, _n, m} = parse(input)

    {{start_i, start_j}, "S"} = Enum.find(maze, fn {_k, v} -> v == "S" end)

    queue = PriorityQueue.push(PriorityQueue.new(), {start_i, start_j, ">"}, 0)

    distances =
      maze
      |> Enum.reduce(Map.new(), fn {{i, j}, v}, distances ->
        distance = 10_000_000

        case v do
          char when char == "." or char == "E" ->
            distances
            |> Map.put({i, j, "^"}, distance)
            |> Map.put({i, j, ">"}, distance)
            |> Map.put({i, j, "v"}, distance)
            |> Map.put({i, j, "<"}, distance)

          _ ->
            distances
        end
      end)
      |> Map.put({start_i, start_j, ">"}, 0)

    {distances, parents} =
      1
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while({queue, distances, MapSet.new(), Map.new()}, fn _, {queue, distances, visited, parents} ->
        case PriorityQueue.pop(queue) do
          {:empty, _} ->
            {:halt, {distances, parents}}

          {{:value, {i, j, direction} = current}, queue} ->
            case maze[{i, j}] do
              "E" ->
                {:cont, {queue, distances, MapSet.put(visited, {i, j, direction}), parents}}

              _ ->
                visited = MapSet.put(visited, {i, j, direction})

                neighbors =
                  case direction do
                    ">" ->
                      [{{i, j + 1, ">"}, 1}, {{i + 1, j, "v"}, 1001}, {{i, j - 1, "<"}, 1001}, {{i - 1, j, "^"}, 1001}]

                    "v" ->
                      [{{i, j + 1, ">"}, 1001}, {{i + 1, j, "v"}, 1}, {{i, j - 1, "<"}, 1001}, {{i - 1, j, "^"}, 1001}]

                    "<" ->
                      [{{i, j + 1, ">"}, 1001}, {{i + 1, j, "v"}, 1001}, {{i, j - 1, "<"}, 1}, {{i - 1, j, "^"}, 1001}]

                    "^" ->
                      [{{i, j + 1, ">"}, 1001}, {{i + 1, j, "v"}, 1001}, {{i, j - 1, "<"}, 1001}, {{i - 1, j, "^"}, 1}]
                  end

                available_neighbors =
                  Enum.filter(neighbors, fn {{i, j, direction}, _} ->
                    not MapSet.member?(visited, {i, j, direction}) and not is_nil(distances[{i, j, direction}])
                  end)

                {queue, distances, parents} =
                  Enum.reduce(
                    available_neighbors,
                    {queue, distances, parents},
                    fn {{neighbor_i, neighbor_j, neighbor_direction} = neighbor, neighbor_distance},
                       {queue, distances, parents} ->
                      new_distance = distances[current] + neighbor_distance

                      {queue, distances, parents} =
                        cond do
                          new_distance < distances[neighbor] ->
                            distances = Map.put(distances, neighbor, new_distance)
                            parents = Map.put(parents, neighbor, [current])

                            queue =
                              PriorityQueue.push(
                                queue,
                                {neighbor_i, neighbor_j, neighbor_direction},
                                distances[{neighbor_i, neighbor_j, neighbor_direction}]
                              )

                            {queue, distances, parents}

                          new_distance == distances[neighbor] ->
                            parents = Map.put(parents, neighbor, parents[neighbor] ++ [current])

                            {queue, distances, parents}

                          true ->
                            {queue, distances, parents}
                        end

                      {queue, distances, parents}
                    end
                  )

                {:cont, {queue, distances, visited, parents}}
            end
        end
      end)

    shortest_path_length = Enum.min([distances[{1, m - 2, "^"}], distances[{1, m - 2, ">"}]])

    case part do
      1 ->
        shortest_path_length

      2 ->
        best_tiles = MapSet.new()

        best_tiles =
          if distances[{1, m - 2, "^"}] == shortest_path_length do
            parents |> bfs({1, m - 2, "^"}) |> MapSet.new(fn {i, j, _direction} -> {i, j} end)
          else
            best_tiles
          end

        best_tiles =
          if distances[{1, m - 2, ">"}] == shortest_path_length do
            visited = parents |> bfs({1, m - 2, ">"}) |> MapSet.new(fn {i, j, _direction} -> {i, j} end)

            MapSet.union(best_tiles, visited)
          else
            best_tiles
          end

        MapSet.size(best_tiles)
    end
  end

  defp bfs(graph, start_node) do
    queue = :queue.in(start_node, :queue.new())

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({queue, MapSet.new()}, fn _, {queue, visited} ->
      case :queue.out(queue) do
        {:empty, _} ->
          {:halt, visited}

        {{:value, current}, queue} ->
          visited = MapSet.put(visited, current)

          case graph[current] do
            nil ->
              {:cont, {queue, visited}}

            neighbors ->
              queue =
                Enum.reduce(neighbors, queue, fn neighbor, queue ->
                  if MapSet.member?(visited, neighbor) do
                    queue
                  else
                    :queue.in(neighbor, queue)
                  end
                end)

              {:cont, {queue, visited}}
          end
      end
    end)
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
