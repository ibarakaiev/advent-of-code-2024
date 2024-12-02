defmodule AdventOfCode2024.Day2Test do
  use ExUnit.Case

  @input """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  test "part 1" do
    assert AdventOfCode2024.Day2.solve(@input, part: 1) == 2
  end

  test "part 2" do
    assert AdventOfCode2024.Day2.solve(@input, part: 2) == 4
  end
end
