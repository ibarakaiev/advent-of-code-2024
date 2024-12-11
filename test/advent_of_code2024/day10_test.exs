defmodule AdventOfCode2024.Day10Test do
  use ExUnit.Case

  @input """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  test "part 1" do
    assert AdventOfCode2024.Day10.solve(@input, part: 1) == 36
  end

  test "part 2" do
    assert AdventOfCode2024.Day10.solve(@input, part: 2) == 81
  end
end
