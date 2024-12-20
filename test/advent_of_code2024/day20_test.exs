defmodule AdventOfCode2024.Day20Test do
  use ExUnit.Case

  @input """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  """

  # test "part 1" do
  #   assert AdventOfCode2024.Day20.solve(@input, part: 1, env: :test) == 44
  # end

  test "part 2" do
    assert AdventOfCode2024.Day20.solve(@input, part: 2, env: :test) == 285
  end
end
