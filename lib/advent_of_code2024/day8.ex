defmodule AdventOfCode2024.Day8 do
  @moduledoc false
  def solve(input, part: part) do
    {occurences, height, width} = parse(input)

    occurences
    |> Enum.reduce(MapSet.new(), fn {_char, locations}, total_set ->
      local_set =
        for {{x1, y1}, i} <- Enum.with_index(locations),
            {{x2, y2}, j} <- Enum.with_index(locations),
            i < j,
            reduce: MapSet.new() do
          set ->
            case part do
              1 ->
                set
                |> add_antinode({x1 + 2 * (x2 - x1), y1 + 2 * (y2 - y1)}, locations, {height, width})
                |> add_antinode({x2 + 2 * (x1 - x2), y2 + 2 * (y1 - y2)}, locations, {height, width})

              2 ->
                Enum.reduce(0..(max(div(width, abs(x2 - x1)), div(height, abs(y2 - y1))) + 1), set, fn i, set ->
                  set
                  |> add_antinode({x1 + i * (x2 - x1), y1 + i * (y2 - y1)}, {height, width})
                  |> add_antinode({x2 + i * (x1 - x2), y2 + i * (y1 - y2)}, {height, width})
                end)
            end
        end

      MapSet.union(local_set, total_set)
    end)
    |> Enum.count()
  end

  defp add_antinode(set, {x, y}, locations, {height, width}) do
    if {x, y} not in locations and within_bounds?({x, y}, {height, width}) do
      MapSet.put(set, {x, y})
    else
      set
    end
  end

  defp add_antinode(set, {x, y}, {height, width}) do
    if within_bounds?({x, y}, {height, width}) do
      MapSet.put(set, {x, y})
    else
      set
    end
  end

  defp within_bounds?({x, y}, {height, width}), do: x >= 0 and x < width and y >= 0 and y < height

  defp parse(input) do
    matrix = input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    occurences =
      for {row, i} <- Enum.with_index(matrix), reduce: %{} do
        acc ->
          for {char, j} <- Enum.with_index(row), reduce: acc do
            acc ->
              if char == "." do
                acc
              else
                Map.put(acc, char, (acc[char] || []) ++ [{i, j}])
              end
          end
      end

    {occurences, length(matrix), length(List.first(matrix))}
  end
end
