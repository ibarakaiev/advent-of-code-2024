defmodule AdventOfCode2024.Day1Test do
  use ExUnit.Case

  @input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "part 1" do
    assert AdventOfCode2024.Day1.solve(@input, part: 1) == 11
  end

  test "part 2" do
    assert AdventOfCode2024.Day1.solve(@input, part: 2) == 31
  end
end
