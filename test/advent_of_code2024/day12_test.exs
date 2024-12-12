defmodule AdventOfCode2024.Day12Test do
  use ExUnit.Case

  @input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  test "part 1.1" do
    assert AdventOfCode2024.Day12.solve(
             """
             AAAA
             BBCD
             BBCC
             EEEC
             """,
             part: 1
           ) == 140
  end

  test "part 1.2" do
    assert AdventOfCode2024.Day12.solve(@input, part: 1) == 1930
  end

  test "part 2.1" do
    assert AdventOfCode2024.Day12.solve(
             """
             EEEEE
             EXXXX
             EEEEE
             EXXXX
             EEEEE
             """,
             part: 2
           ) == 236
  end

  test "part 2.2" do
    assert AdventOfCode2024.Day12.solve(
             """
             AAAAAA
             AAABBA
             AAABBA
             ABBAAA
             ABBAAA
             AAAAAA
             """,
             part: 2
           ) == 368
  end

  test "part 2.3" do
    assert AdventOfCode2024.Day12.solve(@input, part: 2) == 1206
  end
end
