defmodule AdventOfCode2024.Day22Test do
  use ExUnit.Case

  @input """
  1
  10
  100
  2024
  """

  test "part 1" do
    assert AdventOfCode2024.Day22.solve(@input, part: 1) == 37_327_623
  end
end
