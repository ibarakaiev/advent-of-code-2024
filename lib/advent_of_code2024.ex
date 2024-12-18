defmodule AdventOfCode2024 do
  @moduledoc """
  Documentation for `AdventOfCode2024`.
  """

  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def print(grid, {n, m}) do
    IO.puts("")

    out =
      for i <- 0..n do
        row =
          for j <- 0..m do
            grid[{i, j}]
          end

        Enum.join(row, "")
      end

    IO.puts(Enum.join(out, "\n"))
  end
end
