defmodule AdventOfCode2024.Day17Test do
  use ExUnit.Case

  import AdventOfCode2024.Day17

  test "If register C contains 9, the program 2,6 would set register B to 1" do
    assert {{_instruction_pointer, _a, 1, _c}, _output} = simulate([2, 6], {0, 0, 0, 9})
  end

  test "If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2." do
    assert {_registers, [0, 1, 2]} = simulate([5, 0, 5, 1, 5, 4], {0, 10, 0, 0})
  end

  test "If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A" do
    assert {{_instruction_pointer, 0, _b, _c}, [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]} =
             simulate([0, 1, 5, 4, 3, 0], {0, 2024, 0, 0})
  end

  test "If register B contains 29, the program 1,7 would set register B to 26" do
    assert {{_instruction_pointer, _a, 26, _c}, _output} = simulate([1, 7], {0, 0, 29, 0})
  end

  test "If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354" do
    assert {{_instruction_pointer, _a, 44_354, _c}, _output} =
             simulate([4, 0], {0, 0, 2024, 43_690})
  end

  test "part 1" do
    assert solve(
             """
             Register A: 729
             Register B: 0
             Register C: 0

             Program: 0,1,5,4,3,0
             """,
             part: 1
           ) == "4,6,3,5,6,3,5,2,1,0"
  end

  test "part 2" do
    assert solve(
             """
             Register A: 2024
             Register B: 0
             Register C: 0

             Program: 0,3,5,4,3,0
             """,
             part: 2
           ) == 117_440
  end
end
