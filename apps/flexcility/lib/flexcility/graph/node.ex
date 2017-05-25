defmodule Flexcility.Graph.Node do
  alias Bolt.Sips, as: Graph
  require IEx

  def map_properties(properties) do
    properties
    |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
  end

  def insert(changeset) do
    case changeset.errors do
      [] ->
        properties_string = properties_from_changeset(changeset)
        Graph.query(Graph.conn, "CREATE (n:User {#{properties_string}}) return n")
      _ -> {:error,changeset}
    end
  end

  defp properties_from_changeset(changeset) do
    changeset.changes
      |> Enum.reduce("", fn({k,v}, acc)->
        acc <> " #{Atom.to_string(k)}: '#{v}',"
      end)
      |> String.trim_trailing(",")
  end
end
