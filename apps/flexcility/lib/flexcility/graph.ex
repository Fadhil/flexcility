defmodule Flexcility.Graph do
  alias Bolt.Sips, as: Bolt

  alias Flexcility.Utils

  def create_node(node_type, changeset) do
    attributes_string = changeset_to_string(changeset)
    node_type_string = Utils.get_resource_name(node_type)
    query = """
      MERGE (id:UniqueId {name: '#{node_type_string}'})
      ON CREATE SET id.count = 1
      ON MATCH SET id.count = id.count + 1
      WITH id.count AS uid
      CREATE (n:#{node_type_string} {id: uid, #{attributes_string}})
      RETURN n as new_#{node_type_string |> String.downcase}
    """

    Bolt.query(Bolt.conn, query)
  end

  def get_node_by_id(node_type, id) do
    node_type_string = Utils.get_resource_name(node_type)
    query = """
      MATCH (n:#{node_type_string} {id: #{id}})
      RETURN n as #{node_type_string |> String.downcase}
    """
    case Bolt.query(Bolt.conn, query) do
      {:ok, [site|_]} ->
        {:ok, site}
      {:ok, []} ->
        {:ok, []}
    end
  end

  def get_nodes_by_label(node_type) do
    node_type_string = Utils.get_resource_name(node_type)
    query = """
      MATCH (n:#{node_type_string})
      RETURN n as #{node_type_string |> String.downcase}
    """

    Bolt.query(Bolt.conn, query)
  end

  defp changeset_to_string(changeset) do
    changeset.changes
    |> Enum.map(fn {key, value} -> "#{key}: '#{value}'" end)
    |> Enum.join(", ")
  end
end