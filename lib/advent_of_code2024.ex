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
end
