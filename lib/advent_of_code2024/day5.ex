defmodule AdventOfCode2024.Day5 do
  @moduledoc false
  def solve(input, part: part) do
    {graph, updates} = parse(input)

    correct_updates =
      Enum.filter(updates, fn update ->
        update
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce_while(true, fn [parent, child], _ ->
          if child in graph[parent] do
            {:cont, true}
          else
            {:halt, false}
          end
        end)
      end)

    case part do
      1 ->
        sum_of_center_elements(correct_updates)

      2 ->
        incorrect_updates =
          Enum.map(updates -- correct_updates, fn incorrect_update ->
            Enum.sort(incorrect_update, &(&1 not in graph[&2]))
          end)

        sum_of_center_elements(incorrect_updates)
    end
  end

  defp sum_of_center_elements(lists) do
    lists
    |> Enum.map(fn list ->
      center_index = div(length(list), 2)

      list |> Enum.at(center_index) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    [rules, updates] = String.split(input, "\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "|", trim: true))

    graph =
      rules
      |> List.flatten()
      |> MapSet.new()
      |> Enum.reduce(%{}, fn node, graph -> Map.put(graph, node, []) end)

    graph =
      Enum.reduce(rules, graph, fn [parent, child], graph ->
        Map.put(graph, parent, Map.fetch!(graph, parent) ++ [child])
      end)

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))

    {graph, updates}
  end
end
