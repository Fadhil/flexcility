defmodule Flexcility.Graph.Node do
  def map_properties(properties) do
    properties
    |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
  end
end
