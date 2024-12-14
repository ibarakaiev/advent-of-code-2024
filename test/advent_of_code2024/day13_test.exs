defmodule AdventOfCode2024.Day13Test do
  use ExUnit.Case

  @input """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """

  test "part 1" do
    assert AdventOfCode2024.Day13.solve(@input, part: 1) == 480
  end

  test "part 2" do
    assert AdventOfCode2024.Day13.solve(@input, part: 2) != 0
  end
end
