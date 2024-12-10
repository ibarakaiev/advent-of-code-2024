defmodule AdventOfCode2024.Day9Test do
  use ExUnit.Case

  @input "2333133121414131402"

  test "part 1" do
    assert AdventOfCode2024.Day9.solve(@input, part: 1) == 1928
  end

  test "part 2" do
    assert AdventOfCode2024.Day9.solve(@input, part: 2) == 2858
  end
end
