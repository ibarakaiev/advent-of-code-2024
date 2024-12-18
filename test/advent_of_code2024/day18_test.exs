defmodule AdventOfCode2024.Day18Test do
  use ExUnit.Case

  @input """
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """

  test "part 1" do
    assert AdventOfCode2024.Day18.solve(@input, part: 1, env: :test) == 22
  end

  test "part 2" do
    assert AdventOfCode2024.Day18.solve(@input, part: 2, env: :test) == {6, 1}
  end
end
