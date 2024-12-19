defmodule AdventOfCode2024.Day19Test do
  use ExUnit.Case

  @input """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """

  test "part 1" do
    assert AdventOfCode2024.Day19.solve(@input, part: 1) == 6
  end

  test "part 2" do
    assert AdventOfCode2024.Day19.solve(@input, part: 2) == 16
  end
end
