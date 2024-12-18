defmodule AdventOfCode2024.Day17 do
  @moduledoc false

  import Bitwise

  def solve(input, part: 1) do
    {a, b, c, program} = parse(input)

    {_registers, output} = simulate(program, {0, a, b, c})

    Enum.join(output, ",")
  end

  def solve(input, part: 2) do
    {_a, _b, _c, program} = parse(input)

    backtrack(program, "", 1)
  end

  defp backtrack(program, a_binary, i) do
    if i == length(program) + 1 do
      String.to_integer(a_binary, 2)
    else
      0..127
      |> Enum.map(fn candidate ->
        candidate_binary = candidate |> Integer.to_string(2) |> String.pad_leading(3, "0")
        extended_a_binary = a_binary <> candidate_binary
        {_, out} = simulate(program, {0, String.to_integer(extended_a_binary, 2), 0, 0})

        if out == Enum.slice(program, length(program) - i, i) do
          backtrack(program, extended_a_binary, i + 1)
        end
      end)
      |> Enum.min()
    end
  end

  def simulate(program, {instruction_pointer, a, b, c}) do
    program = Map.new(Enum.zip(0..(length(program) - 1), program))

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(
      {{instruction_pointer, a, b, c}, []},
      fn _, {{instruction_pointer, _a, _b, _c} = registers, output} ->
        case program[instruction_pointer] do
          nil ->
            {:halt, {registers, output}}

          opcode ->
            operand = program[instruction_pointer + 1]

            {:cont, execute(opcode, operand, registers, output)}
        end
      end
    )
  end

  defp combo(operand, {_instruction_pointer, a, b, c}) do
    case operand do
      number when number >= 0 and number <= 3 -> number
      4 -> a
      5 -> b
      6 -> c
      7 -> raise "reserved operator"
    end
  end

  defp execute(opcode, operand, registers, output) when is_number(opcode) do
    instruction =
      case opcode do
        0 -> :adv
        1 -> :bxl
        2 -> :bst
        3 -> :jnz
        4 -> :bxc
        5 -> :out
        6 -> :bdv
        7 -> :cdv
      end

    execute(instruction, operand, registers, output)
  end

  defp execute(:adv, operand, {instruction_pointer, _a, b, c} = registers, output) do
    {{instruction_pointer + 2, division(operand, registers), b, c}, output}
  end

  defp execute(:bxl, operand, {instruction_pointer, a, b, c} = _registers, output) do
    {{instruction_pointer + 2, a, bxor(b, operand), c}, output}
  end

  defp execute(:bst, operand, {instruction_pointer, a, _b, c} = registers, output) do
    {{instruction_pointer + 2, a, rem(combo(operand, registers), 8), c}, output}
  end

  defp execute(:jnz, operand, {instruction_pointer, a, b, c} = _registers, output) do
    case a do
      0 -> {{instruction_pointer + 2, a, b, c}, output}
      _ -> {{operand, a, b, c}, output}
    end
  end

  defp execute(:bxc, _operand, {instruction_pointer, a, b, c} = _registers, output) do
    {{instruction_pointer + 2, a, bxor(b, c), c}, output}
  end

  defp execute(:out, operand, {instruction_pointer, a, b, c} = registers, output) do
    {{instruction_pointer + 2, a, b, c}, output ++ [rem(combo(operand, registers), 8)]}
  end

  defp execute(:bdv, operand, {instruction_pointer, a, _b, c} = registers, output) do
    {{instruction_pointer + 2, a, division(operand, registers), c}, output}
  end

  defp execute(:cdv, operand, {instruction_pointer, a, b, _c} = registers, output) do
    {{instruction_pointer + 2, a, b, division(operand, registers)}, output}
  end

  defp division(operand, {_instruction_pointer, a, _b, _c} = registers) do
    numerator = a
    denominator = 2 ** combo(operand, registers)

    div(numerator, denominator)
  end

  defp parse(input) do
    %{"a" => a, "b" => b, "c" => c, "program" => program} =
      Regex.named_captures(
        ~r/Register A:\s(?<a>\d+)\s+Register B:\s(?<b>\d+)\s+Register C:\s(?<c>\d+)\s+Program:\s(?<program>[0-9,]+)/,
        input
      )

    {
      String.to_integer(a),
      String.to_integer(b),
      String.to_integer(c),
      program |> String.split(",") |> Enum.map(&String.to_integer/1)
    }
  end
end
