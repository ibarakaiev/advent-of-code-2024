defmodule AdventOfCode2024.Day21 do
  @moduledoc false
  keypad_to_map = fn layout ->
    for {row, i} <- Enum.with_index(String.split(layout, "\n", trim: true)),
        {char, j} <- Enum.with_index(String.graphemes(row)),
        reduce: %{} do
      acc ->
        case char do
          " " -> acc
          _ -> Map.put(acc, char, {i, j})
        end
    end
  end

  @numeric_keypad keypad_to_map.("""
                  789
                  456
                  123
                   0A
                  """)

  @directional_keypad keypad_to_map.("""
                       ^A
                      <v>
                      """)

  def solve(input, part: part) do
    numbers = input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)

    number_of_indirect_directional_keypads =
      case part do
        1 -> 2
        2 -> 25
      end

    numbers
    |> Enum.map(fn number ->
      {sequence, _} = expand_sequence(number, List.duplicate("A", number_of_indirect_directional_keypads + 1), 0)

      numeric_part = number |> Enum.reject(&(&1 == "A")) |> Enum.join() |> String.to_integer()

      sequence * numeric_part
    end)
    |> Enum.sum()
  end

  def expand_sequence(sequence, [], _level) do
    {Enum.count(sequence), []}
  end

  def expand_sequence(sequence, current_directional_chars, level) do
    memoized({sequence, current_directional_chars}, fn ->
      Enum.reduce(
        sequence,
        {0, current_directional_chars},
        fn target_char, {acc, [current_directional_char | rest_of_directional_chars]} ->
          current_directional_char
          |> sequence_for_keypad(target_char, if(level == 0, do: :numeric, else: :directional))
          |> Enum.map(fn sequence ->
            {expanded_next_sequence, updated_rest_of_directional_chars} =
              expand_sequence(sequence, rest_of_directional_chars, level + 1)

            {acc + expanded_next_sequence, [target_char | updated_rest_of_directional_chars]}
          end)
          |> Enum.min_by(fn {sequence_length, _} -> sequence_length end)
        end
      )
    end)
  end

  defp memoized(key, fun) do
    case Process.get(key) do
      nil ->
        result = fun.()

        Process.put(key, result)

        result

      v ->
        v
    end
  end

  defp sequence_for_keypad(starting_char, target_char, keypad_type) do
    keypad =
      case keypad_type do
        :numeric -> @numeric_keypad
        :directional -> @directional_keypad
      end

    {starting_i, starting_j} = keypad[starting_char]
    {target_i, target_j} = keypad[target_char]

    horizontal_moves = List.duplicate(if(target_j > starting_j, do: ">", else: "<"), abs(target_j - starting_j))
    vertical_moves = List.duplicate(if(target_i > starting_i, do: "v", else: "^"), abs(target_i - starting_i))

    cond do
      (keypad_type == :numeric and starting_i == 3 and target_j == 0) or
          (keypad_type == :directional and starting_i == 0 and target_j == 0) ->
        [vertical_moves ++ horizontal_moves ++ ["A"]]

      (keypad_type == :numeric and starting_j == 0 and target_i == 3) or
          (keypad_type == :directional and starting_j == 0 and target_i == 0) ->
        [horizontal_moves ++ vertical_moves ++ ["A"]]

      true ->
        [horizontal_moves ++ vertical_moves ++ ["A"], vertical_moves ++ horizontal_moves ++ ["A"]]
    end
  end
end
