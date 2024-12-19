defmodule AdventOfCode2024.Day19Trie do
  @moduledoc false

  def solve(input, part: part) do
    {trie, designs} = parse(input)

    table = :ets.new(:memoization, [:named_table])

    answer =
      case part do
        1 -> Enum.count(designs, &possible?(&1, trie, %{nil: true}, part: part))
        2 -> designs |> Enum.map(&possible?(&1, trie, %{nil: true}, part: part)) |> Enum.sum()
      end

    :ets.delete_all_objects(table)

    answer
  end

  def possible?("", _trie, %{nil: true}, part: 1), do: true
  def possible?("", _trie, _subtrie, part: 1), do: false
  def possible?(_design, _trie, nil, part: 1), do: false

  def possible?("", _trie, %{nil: true}, part: 2), do: 1
  def possible?("", _trie, _subtrie, part: 2), do: 0
  def possible?(_design, _trie, nil, part: 2), do: 0

  def possible?(design, trie, subtrie, part: part) do
    {first_char, rest} = String.split_at(design, 1)

    case :ets.lookup(:memoization, {design, trie, subtrie}) do
      [{_, value}] ->
        value

      _ ->
        possible_with_trie? =
          if Map.has_key?(subtrie, nil) do
            possible?(rest, trie, trie[first_char], part: part)
          else
            case part do
              1 -> false
              2 -> 0
            end
          end

        possible_with_subtrie? = possible?(rest, trie, subtrie[first_char], part: part)

        result =
          case part do
            1 -> possible_with_trie? or possible_with_subtrie?
            2 -> possible_with_trie? + possible_with_subtrie?
          end

        :ets.insert(:memoization, {{design, trie, subtrie}, result})

        result
    end
  end

  defp parse(input) do
    [available_patterns, designs] = String.split(input, "\n\n", parts: 2, trim: true)

    trie = available_patterns |> String.split(", ", trim: true) |> Trie.new()

    {trie, String.split(designs, "\n", trim: true)}
  end
end
