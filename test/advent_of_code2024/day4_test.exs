defmodule AdventOfCode2024.Day4Test do
  use ExUnit.Case

  @input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  test "part 1" do
    assert AdventOfCode2024.Day4.solve(@input, part: 1) == 18
  end

  test "part 2" do
    assert AdventOfCode2024.Day4.solve(@input, part: 2) == 9
  end
end
