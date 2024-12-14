defmodule AdventOfCode2024.Day14 do
  @moduledoc false
  def solve(input, part: 1, env: env) do
    {width, height} =
      case env do
        :test ->
          {11, 7}

        :prod ->
          {101, 103}
      end

    input
    |> parse()
    |> Enum.reduce(
      %{top_left: 0, top_right: 0, bottom_left: 0, bottom_right: 0},
      fn %{position: position, velocity: velocity}, acc ->
        {new_x, new_y} =
          {modulo(position[:x] + 100 * velocity[:x], width), modulo(position[:y] + 100 * velocity[:y], height)}

        cond do
          new_x < div(width, 2) and new_y < div(height, 2) ->
            Map.put(acc, :top_left, acc[:top_left] + 1)

          new_x < div(width, 2) and new_y > div(height, 2) ->
            Map.put(acc, :bottom_left, acc[:bottom_left] + 1)

          new_x > div(width, 2) and new_y < div(height, 2) ->
            Map.put(acc, :top_right, acc[:top_right] + 1)

          new_x > div(width, 2) and new_y > div(height, 2) ->
            Map.put(acc, :bottom_right, acc[:bottom_right] + 1)

          true ->
            acc
        end
      end
    )
    |> Enum.reduce(1, fn {_k, v}, acc -> acc * v end)
  end

  def solve(input, part: 2) do
    robots = parse(input)

    {width, height} = {101, 103}

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(nil, fn i, _ ->
      positions =
        Enum.reduce(robots, MapSet.new(), fn %{position: position, velocity: velocity}, acc ->
          {new_x, new_y} =
            {modulo(position[:x] + i * velocity[:x], width), modulo(position[:y] + i * velocity[:y], height)}

          MapSet.put(acc, {new_x, new_y})
        end)

      if MapSet.size(positions) == length(robots) do
        {:halt, i}
      else
        {:cont, nil}
      end
    end)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(input) do
    # Use a regular expression to extract the coordinates
    regex = ~r/p=(?<px>-?\d+),(?<py>-?\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/

    case Regex.named_captures(regex, input) do
      %{"px" => px, "py" => py, "vx" => vx, "vy" => vy} ->
        %{
          position: %{x: String.to_integer(px), y: String.to_integer(py)},
          velocity: %{x: String.to_integer(vx), y: String.to_integer(vy)}
        }

      _ ->
        {:error, "Invalid input format"}
    end
  end

  def modulo(a, b) when is_integer(a) and is_integer(b) and b > 0 do
    a
    |> rem(b)
    |> normalize_remainder(b)
  end

  defp normalize_remainder(r, b) when r < 0, do: r + b
  defp normalize_remainder(r, _b), do: r
end
