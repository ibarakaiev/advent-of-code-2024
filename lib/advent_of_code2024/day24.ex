defmodule AdventOfCode2024.Day24 do
  @moduledoc false
  def solve(input, part: 1) do
    {registers, expressions} = parse(input)

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({expressions, registers}, fn _, {expressions, registers} ->
      {possible_expressions, delayed_expressions} =
        Enum.split_with(expressions, fn {register1, _, register2, _} ->
          Map.has_key?(registers, register1) and Map.has_key?(registers, register2)
        end)

      registers =
        Enum.reduce(possible_expressions, registers, fn {register1, operation, register2, output}, registers ->
          output_value =
            case operation do
              :AND -> if(registers[register1] == 1 and registers[register2] == 1, do: 1, else: 0)
              :OR -> if(registers[register1] == 1 or registers[register2] == 1, do: 1, else: 0)
              :XOR -> if(registers[register1] == registers[register2], do: 0, else: 1)
            end

          Map.put(registers, output, output_value)
        end)

      if delayed_expressions == [] do
        {:halt, registers}
      else
        {:cont, {delayed_expressions, registers}}
      end
    end)
    |> Enum.filter(fn {k, _v} -> String.starts_with?(k, "z") end)
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> Enum.reduce("", fn {_k, v}, acc -> Integer.to_string(v) <> acc end)
    |> String.to_integer(2)
  end

  defp parse(input) do
    [registers, expressions] = String.split(input, "\n\n", parts: 2, trim: true)

    registers =
      registers
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        [register, value] = String.split(line, ": ", parts: 2, trim: true)

        Map.put(acc, register, String.to_integer(value))
      end)

    expressions =
      expressions
      |> String.split("\n", trim: true)
      |> Enum.reduce([], fn line, acc ->
        [instruction, output] = String.split(line, " -> ", parts: 2, trim: true)

        [register1, operation, register2] = String.split(instruction, " ", trim: true, parts: 3)

        [{register1, String.to_atom(operation), register2, output} | acc]
      end)
      |> Enum.reverse()

    {registers, expressions}
  end
end
