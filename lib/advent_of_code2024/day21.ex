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

  def solve(input, part: 1) do
    numbers = String.split(input, "\n", trim: true)

    numbers
    |> Enum.map(fn number ->
      # keypad <- first_directional_keypad <- second_directional_keypad <- third_directional_keypad (entered manually, doesn't matter)
      {sequence, _} =
        number
        |> String.graphemes()
        |> Enum.reduce(
          {[], {"A", "A", "A"}},
          fn target_char, {sequence, {current_numeric_char, current_directional1_char, current_directional2_char}} ->
            first_to_numeric_sequence = sequence_for_numeric_keypad(current_numeric_char, target_char)

            {sequence_rest, {current_directional1_char, current_directional2_char}} =
              Enum.reduce(
                first_to_numeric_sequence,
                {[], {current_directional1_char, current_directional2_char}},
                fn target_char, {sequence, {current_directional1_char, current_directional2_char}} ->
                  second_to_first_sequence = sequence_for_directional_keypad(current_directional1_char, target_char)

                  {sequence_rest, current_directional2_char} =
                    Enum.reduce(
                      second_to_first_sequence,
                      {[], current_directional2_char},
                      fn target_char, {sequence, current_directional2_char} ->
                        third_to_second = sequence_for_directional_keypad(current_directional2_char, target_char)

                        {sequence ++ third_to_second, target_char}
                      end
                    )

                  {sequence ++ sequence_rest, {target_char, current_directional2_char}}
                end
              )

            {sequence ++ sequence_rest, {target_char, current_directional1_char, current_directional2_char}}
          end
        )

      length(sequence) * String.to_integer(String.slice(number, 0..2))
    end)
    |> Enum.sum()
  end

  defp sequence_for_numeric_keypad(starting_char, target_char) do
    {starting_i, starting_j} = @numeric_keypad[starting_char]
    {ending_i, ending_j} = @numeric_keypad[target_char]

    horizontal_moves = List.duplicate(if(ending_j > starting_j, do: ">", else: "<"), abs(ending_j - starting_j))
    vertical_moves = List.duplicate(if(ending_i > starting_i, do: "v", else: "^"), abs(ending_i - starting_i))

    if starting_i == 3 and ending_j == 0 do
      vertical_moves ++ horizontal_moves ++ ["A"]
    else
      horizontal_moves ++ vertical_moves ++ ["A"]
    end
  end

  defp sequence_for_directional_keypad(starting_char, target_char) do
    {starting_i, starting_j} = @directional_keypad[starting_char]
    {ending_i, ending_j} = @directional_keypad[target_char]

    horizontal_moves = List.duplicate(if(ending_j > starting_j, do: ">", else: "<"), abs(ending_j - starting_j))
    vertical_moves = List.duplicate(if(ending_i > starting_i, do: "v", else: "^"), abs(ending_i - starting_i))

    if starting_i == 0 and ending_j == 0 do
      vertical_moves ++ horizontal_moves ++ ["A"]
    else
      horizontal_moves ++ vertical_moves ++ ["A"]
    end
  end
end
