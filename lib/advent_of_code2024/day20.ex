defmodule AdventOfCode2024.Day20 do
  @moduledoc false
  def solve(input, [{:part, part} | _] = opts) do
    env = Keyword.get(opts, :env, :prod)

    {maze, {_n, _m}} = parse(input)

    {{start_i, start_j}, "S"} = Enum.find(maze, fn {_k, v} -> v == "S" end)

    path = bfs(maze, {start_i, start_j})

    path_length = map_size(path)

    max_distance =
      case part do
        1 -> 2
        2 -> 20
      end

    min_cheating_distance =
      case env do
        :test ->
          case part do
            1 -> 0
            2 -> 50
          end

        :prod ->
          100
      end

    frequencies =
      1
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while({[], {start_i, start_j}}, fn _, {saved_distances, {i, j}} ->
        case path[{i, j}] do
          nil ->
            {:halt, saved_distances}

          {next_coordinates, current_level} ->
            saved_distances =
              for neighbor <- neighbors_within_distance(maze, {i, j}, max_distance), reduce: saved_distances do
                saved_distances ->
                  neighbor_level =
                    case maze[neighbor] do
                      "E" ->
                        path_length

                      "." ->
                        case path[neighbor] do
                          {_neighbor_next_coordinates, neighbor_level} ->
                            neighbor_level

                          _ ->
                            nil
                        end
                    end

                  if neighbor_level && neighbor_level - current_level - max_distance > 0 do
                    [neighbor_level - current_level - max_distance | saved_distances]
                  else
                    saved_distances
                  end
              end

            {:cont, {saved_distances, next_coordinates}}
        end
      end)
      |> Enum.frequencies()
      |> Enum.filter(fn {k, _v} -> k >= min_cheating_distance end)
      |> Map.new()

    frequencies
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  defp bfs(maze, {start_i, start_j}) do
    queue = :queue.in({{start_i, start_j}, 0}, :queue.new())

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({queue, MapSet.new(), %{}}, fn _, {queue, visited, path} ->
      case :queue.out(queue) do
        {:empty, _} ->
          {:halt, path}

        {{:value, {{i, j}, level}}, queue} ->
          visited = MapSet.put(visited, {i, j})

          {queue, path} =
            Enum.reduce([{0, 1}, {1, 0}, {0, -1}, {-1, 0}], {queue, path}, fn {d_i, d_j}, {queue, path} ->
              if (maze[{i + d_i, j + d_j}] == "." or maze[{i + d_i, j + d_j}] == "E") and
                   not MapSet.member?(visited, {i + d_i, j + d_j}) do
                {:queue.in({{i + d_i, j + d_j}, level + 1}, queue), Map.put(path, {i, j}, {{i + d_i, j + d_j}, level})}
              else
                {queue, path}
              end
            end)

          {:cont, {queue, visited, path}}
      end
    end)
  end

  defp neighbors_within_distance(maze, {i, j}, max_distance) do
    [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    |> Stream.cycle()
    |> Stream.chunk_every(2, 1)
    |> Stream.take(4)
    |> Enum.flat_map(fn [{d_i_1, d_j_1}, {d_i_2, d_j_2}] ->
      reachable_coordinates =
        for distance <- 1..max_distance, k <- 0..(distance - 1) do
          {i + d_i_1 * k + d_i_2 * (distance - k), j + d_j_1 * k + d_j_2 * (distance - k)}
        end

      Enum.filter(reachable_coordinates, fn {i, j} -> maze[{i, j}] == "." or maze[{i, j}] == "E" end)
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

    {map, {length(matrix), length(List.first(matrix))}}
  end
end

