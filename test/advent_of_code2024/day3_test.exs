defmodule AdventOfCode2024.Day3Test do
  use ExUnit.Case

  test "part 1" do
    assert AdventOfCode2024.Day3.solve(
             "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))",
             part: 1
           ) == 161
  end

  test "part 2" do
    assert AdventOfCode2024.Day3.solve(
             "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))",
             part: 2
           ) == 48
  end
end
