defmodule AdventOfCode2024.Day7Test do
  use ExUnit.Case

  @input """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  test "part 1" do
    assert AdventOfCode2024.Day7.solve(@input, part: 1) == 3749
  end

  test "part 2" do
    assert AdventOfCode2024.Day7.solve(@input, part: 2) == 11_387
  end
end
