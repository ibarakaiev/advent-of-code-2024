defmodule AdventOfCode2024.Day6Test do
  use ExUnit.Case

  @input """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  test "part 1" do
    assert AdventOfCode2024.Day6.solve(@input, part: 1) == 41
  end

  test "part 2" do
    assert AdventOfCode2024.Day6.solve(@input, part: 2) == 6
  end
end
