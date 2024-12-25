defmodule AdventOfCode2024.Day25Test do
  use ExUnit.Case

  @input """
  #####
  .####
  .####
  .####
  .#.#.
  .#...
  .....

  #####
  ##.##
  .#.##
  ...##
  ...#.
  ...#.
  .....

  .....
  #....
  #....
  #...#
  #.#.#
  #.###
  #####

  .....
  .....
  #.#..
  ###..
  ###.#
  ###.#
  #####

  .....
  .....
  .....
  #....
  #.#..
  #.#.#
  #####
  """

  test "part 1" do
    assert AdventOfCode2024.Day25.solve(@input, part: 1) == 3
  end
end
