defmodule AdventOfCode2024.Day21Test do
  use ExUnit.Case

  @input """
  029A
  980A
  179A
  456A
  379A
  """

  test "part 1" do
    assert AdventOfCode2024.Day21.solve(@input, part: 1) == 126_384
  end
end
