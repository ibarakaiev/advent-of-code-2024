defmodule AdventOfCode2024.Day15Test do
  use ExUnit.Case

  @input """
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########

  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  """

  test "part 1.1" do
    assert AdventOfCode2024.Day15.solve(
             """
             ########
             #..O.O.#
             ##@.O..#
             #...O..#
             #.#.O..#
             #...O..#
             #......#
             ########

             <^^>>>vv<v>>v<<
             """,
             part: 1
           ) == 2028
  end

  test "part 1.2" do
    assert AdventOfCode2024.Day15.solve(
             @input,
             part: 1
           ) == 10_092
  end

  test "part 2.1" do
    assert AdventOfCode2024.Day15.solve(
             """
             #######
             #...#.#
             #.....#
             #..OO@#
             #..O..#
             #.....#
             #######

             <vv<<^^<<^^
             """,
             part: 2
           ) != 0
  end

  test "part 2.2" do
    assert AdventOfCode2024.Day15.solve(
             @input,
             part: 2
           ) == 9021
  end
end
