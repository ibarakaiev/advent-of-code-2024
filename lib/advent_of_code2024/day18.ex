defmodule AdventOfCode2024.Day18 do
  @moduledoc false

  def solve(input, [{:part, 1} | _] = opts) do
    env = Keyword.get(opts, :env, :prod)

    coordinates = input |> parse(part: 1, env: env) |> MapSet.new()

    # inclusive
    {width, height} =
      case env do
        :prod -> {70, 70}
        :test -> {6, 6}
      end

    grid = construct_grid({width, height}, coordinates)

    bfs(grid, {height, width})
  end

  def solve(input, [{:part, 2} | _] = opts) do
    env = Keyword.get(opts, :env, :prod)

    coordinates = parse(input, part: 2)

    n = length(coordinates)

    # inclusive
    {width, height} =
      case env do
        :prod -> {70, 70}
        :test -> {6, 6}
      end

    index =
      1
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while({0, n - 1, 0}, fn _, {l, r, prev_non_nil} ->
        if l == r - 1 do
          {:halt, prev_non_nil}
        else
          mid = l + div(r - l, 2)

          coordinates_l = Enum.take(coordinates, mid)
          grid_l = construct_grid({width, height}, coordinates_l)

          coordinates_r = Enum.take(coordinates, mid + 1)
          grid_r = construct_grid({width, height}, coordinates_r)

          case {bfs(grid_l, {height, width}), bfs(grid_r, {height, width})} do
            {nil, nil} ->
              {:cont, {l, mid, prev_non_nil}}

            {value, nil} when is_number(value) ->
              {:halt, mid}

            {_, _} ->
              {:cont, {mid, r, mid}}
          end
        end
      end)

    Enum.at(coordinates, index)
  end

  def bfs(grid, {height, width}) do
    queue = :queue.in({{0, 0}, 0}, :queue.new())

    distances =
      1
      |> Stream.iterate(&(&1 + 1))
      |> Enum.reduce_while({queue, MapSet.new(), Map.new()}, fn _, {queue, visited, distances} ->
        case :queue.out(queue) do
          {:empty, _} ->
            {:halt, distances}

          {{:value, {{i, j}, level}}, queue} ->
            if MapSet.member?(visited, {i, j}) do
              {:cont, {queue, visited, distances}}
            else
              distances = Map.put(distances, {i, j}, level)
              visited = MapSet.put(visited, {i, j})

              queue =
                Enum.reduce([{-1, 0}, {0, 1}, {1, 0}, {0, -1}], queue, fn {d_i, d_j}, queue ->
                  if grid[{i + d_i, j + d_j}] == "." do
                    :queue.in({{i + d_i, j + d_j}, level + 1}, queue)
                  else
                    queue
                  end
                end)

              {:cont, {queue, visited, distances}}
            end
        end
      end)

    distances[{height, width}]
  end

  def construct_grid({width, height}, coordinates) do
    coordinates = MapSet.new(coordinates)

    for i <- 0..height, reduce: Map.new() do
      map ->
        for j <- 0..width, reduce: map do
          map ->
            if MapSet.member?(coordinates, {j, i}) do
              Map.put(map, {i, j}, "#")
            else
              Map.put(map, {i, j}, ".")
            end
        end
    end
  end

  def parse(input, [{:part, part} | _] = opts) do
    rows = String.split(input, "\n", trim: true)

    env = Keyword.get(opts, :env, :prod)

    rows =
      case part do
        1 ->
          case env do
            :test -> Enum.take(rows, 12)
            :prod -> Enum.take(rows, 1024)
          end

        2 ->
          rows
      end

    Enum.map(rows, fn row ->
      [l, r] = String.split(row, ",", trim: true, parts: 2)

      {String.to_integer(l), String.to_integer(r)}
    end)
  end
end
