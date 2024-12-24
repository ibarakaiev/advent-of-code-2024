defmodule AdventOfCode2024.Day23 do
  @moduledoc false
  def solve(input, part: part) do
    graph = parse(input)

    case part do
      1 ->
        graph
        |> Map.keys()
        |> Enum.map(fn node ->
          dfs(graph, {node, MapSet.new([node]), 1}, 3)
        end)
        |> List.flatten()
        |> Enum.reject(&is_nil(&1))
        |> MapSet.new()
        |> Enum.filter(fn set -> Enum.any?(set, &String.starts_with?(&1, "t")) end)
        |> length()

      2 ->
        vertices =
          graph
          |> Map.keys()
          |> Enum.sort()

        graph |> max_clique(vertices, [], []) |> Enum.sort() |> Enum.join(",")
    end
  end

  defp dfs(_graph, {_current_node, group, level}, target_level) when level == target_level, do: group

  defp dfs(graph, {current_node, group, level}, target_level) do
    neighbors = graph[current_node]

    neighbors
    |> Enum.filter(fn neighbor ->
      current_node != neighbor and not MapSet.member?(group, neighbor) and
        MapSet.subset?(group, MapSet.new(graph[neighbor]))
    end)
    |> Enum.map(&dfs(graph, {&1, MapSet.put(group, &1), level + 1}, target_level))
  end

  defp max_clique(_graph, [], current_clique, max_clique) do
    if length(current_clique) > length(max_clique), do: current_clique, else: max_clique
  end

  defp max_clique(graph, [vertex | rest], current_clique, max_clique) do
    new_candidates = Enum.filter(rest, &Enum.member?(graph[vertex], &1))

    with_vertex =
      if length(current_clique) + length(new_candidates) > length(max_clique) do
        max_clique(graph, new_candidates, [vertex | current_clique], max_clique)
      else
        max_clique
      end

    without_vertex = max_clique(graph, rest, current_clique, max_clique)

    if length(with_vertex) > length(without_vertex), do: with_vertex, else: without_vertex
  end

  def parse(input) do
    edges =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn edge ->
        [node1, node2] = String.split(edge, "-", parts: 2, trim: true)

        {node1, node2}
      end)

    Enum.reduce(edges, %{}, fn {left, right}, graph ->
      graph
      |> Map.put(left, [right] ++ (graph[left] || []))
      |> Map.put(right, [left] ++ (graph[right] || []))
    end)
  end
end
