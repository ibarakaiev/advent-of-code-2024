defmodule Trie do
  @moduledoc false
  def new, do: %{}

  def new(strings) do
    Enum.reduce(strings, %{}, fn string, trie ->
      insert(trie, string)
    end)
  end

  def insert(trie, string)

  def insert(trie, []), do: Map.put(trie, nil, true)

  def insert(trie, binary) when is_binary(binary) do
    insert(trie, String.graphemes(binary))
  end

  def insert(trie, [head | tail]) do
    updated_subtrie =
      trie
      |> Map.get(head, %{})
      |> insert(tail)

    Map.put(trie, head, updated_subtrie)
  end
end
