defmodule AdventOfCode2024.Day22Test do
  use ExUnit.Case

  test "part 1" do
    assert AdventOfCode2024.Day22.solve(
             """
             1
             10
             100
             2024
             """,
             part: 1
           ) == 37_327_623
  end

  test "part 2" do
    assert AdventOfCode2024.Day22.solve(
             """
             1
             2
             3
             2024
             """,
             part: 2
           ) == 23
  end
end
