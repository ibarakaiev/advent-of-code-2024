defmodule AdventOfCode2024.Day4 do
  def solve(input, part: 1) do
    matrix = parse(input)

    matrix
    |> Stream.map(fn {{x, y}, _char} ->
      for d_x <- -1..1, d_y <- -1..1, {d_x, d_y} != {0, 0}, reduce: 0 do
        acc ->
          with "X" <- matrix[{x, y}],
               "M" <- matrix[{x + d_x, y + d_y}],
               "A" <- matrix[{x + 2 * d_x, y + 2 * d_y}],
               "S" <- matrix[{x + 3 * d_x, y + 3 * d_y}] do
            acc + 1
          else
            _ -> acc
          end
      end
    end)
    |> Enum.sum()
  end

  def solve(input, part: 2) do
    matrix = parse(input)

    directions =
      [{-1, -1}, {-1, 1}, {1, 1}, {1, -1}]
      |> then(fn directions ->
        Enum.zip([
          directions,
          Enum.slice(directions, 1..(length(directions) - 1)) ++
            Enum.slice(directions, 0..0)
        ])
      end)

    matrix
    |> Enum.map(fn {{x, y}, _char} ->
      for {{d_x_1, d_y_1}, {d_x_2, d_y_2}} <- directions,
          reduce: 0 do
        acc ->
          with "M" <- matrix[{x, y}],
               "A" <- matrix[{x + d_x_1, y + d_y_1}],
               "S" <- matrix[{x + 2 * d_x_1, y + 2 * d_y_1}],
               "M" <- matrix[{x + d_x_1 - d_x_2, y + d_y_1 - d_y_2}],
               "S" <- matrix[{x + d_x_1 + d_x_2, y + d_y_1 + d_y_2}] do
            acc + 1
          else
            _ -> acc
          end
      end
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    matrix = String.split(input, "\n", trim: true) |> Enum.map(&String.graphemes/1)

    for {row, i} <- Enum.with_index(matrix), reduce: %{} do
      acc ->
        for {char, j} <- Enum.with_index(row), reduce: acc do
          acc ->
            Map.put(acc, {i, j}, char)
        end
    end
  end
end
