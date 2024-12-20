defmodule AdventOfCode2024.Day20 do
  @moduledoc false
  def solve(input, [{:part, part} | _] = opts) do
    env = Keyword.get(opts, :env, :prod)

    {maze, {_n, _m}} = parse(input)

    {{start_i, start_j}, "S"} = Enum.find(maze, fn {_k, v} -> v == "S" end)

    path = bfs(maze, {start_i, start_j})

    max_cheating_distance =
      case part do
        1 -> 2
        2 -> 20
      end

    min_saved_milliseconds =
      case env do
        :test ->
          case part do
            1 -> 0
            2 -> 50
          end

        :prod ->
          100
      end

    for {current_node, i} <- Enum.with_index(path),
        {later_node, j} <- Enum.with_index(path),
        i < j,
        reduce: 0 do
      total ->
        manhattan_distance = manhattan_distance(current_node, later_node)

        if manhattan_distance <= max_cheating_distance do
          saved_milliseconds = j - i - manhattan_distance

          if saved_milliseconds >= min_saved_milliseconds do
            total + 1
          else
            total
          end
        else
          total
        end
    end
  end

  defp bfs(maze, {start_i, start_j}) do
    queue = :queue.in({{start_i, start_j}, 0}, :queue.new())

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({queue, MapSet.new(), [{start_i, start_j}]}, fn _, {queue, visited, path} ->
      case :queue.out(queue) do
        {:empty, _} ->
          {:halt, path}

        {{:value, {{i, j}, level}}, queue} ->
          visited = MapSet.put(visited, {i, j})

          {queue, path} =
            Enum.reduce([{0, 1}, {1, 0}, {0, -1}, {-1, 0}], {queue, path}, fn {d_i, d_j}, {queue, path} ->
              if (maze[{i + d_i, j + d_j}] == "." or maze[{i + d_i, j + d_j}] == "E") and
                   not MapSet.member?(visited, {i + d_i, j + d_j}) do
                {:queue.in({{i + d_i, j + d_j}, level + 1}, queue), [{i + d_i, j + d_j} | path]}
              else
                {queue, path}
              end
            end)

          {:cont, {queue, visited, path}}
      end
    end)
    |> Enum.reverse()
  end

  defp manhattan_distance({first_i, first_j}, {second_i, second_j}) do
    abs(second_i - first_i) + abs(second_j - first_j)
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
