defmodule AdventOfCode2024.Day11Test do
  use ExUnit.Case

  @input "125 17"

  test "part 1" do
    assert AdventOfCode2024.Day11.solve(@input, part: 1) == 55_312
  end
end
