defmodule Flexcility.Graph do
  alias Bolt.Sips, as: Bolt

  alias Flexcility.Utils
  import Flexcility.Graph.Property

  def create_node(node_type, changeset) do
    attributes_string = create_changeset_to_string(changeset)
    node_type_string = node_type.__schema__(:source)
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

  def get(resource, id) do
    case get_node_by_id(resource, id) do
      {:ok, []} ->
        {:error, "#{resource |> Utils.get_resource_name} does not exist"}
      {:ok, item} ->
        {:ok, item|> Utils.get_struct(resource)}
    end
  end

  def get!(resource, id) do
    case get(resource, id) do
      {:ok, item} ->
        item
      {:error, message} ->
        {:error, message}
    end
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

  def all(resource_type) do
    case get_nodes_by_label(resource_type) do
      {:ok, []} ->
        []
      {:ok, items} ->
        items |> Enum.map(&Utils.get_struct(&1, resource_type))
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

  def update(changeset) do
    attributes_to_change_string = update_create_changeset_to_string(changeset, "n")
    node_id = changeset.data.id
    node_type = changeset.data.__struct__
    node_type_string = Utils.get_resource_name(node_type)
    query = "MATCH (n:#{node_type_string} {id: #{node_id}})"

    query = case attributes_to_change_string do
      "" -> query
      _ -> query <> " SET #{attributes_to_change_string}"
    end

    query = query <> " RETURN n as #{node_type_string |> String.downcase}"

    case Bolt.query(Bolt.conn, query) do
      {:ok, [item|_]} ->
        {:ok, item |> Utils.get_struct(node_type)}
    end
  end

  def delete(struct) do
    node_type_string = struct.__struct__ |> Utils.get_resource_name()
    query = """
      MATCH (n:#{node_type_string} {id: #{struct.id}}) DETACH DELETE n
    """

    case Bolt.query(Bolt.conn, query) do
      {:ok, %{stats: nil}} ->
        {:error, "No nodes deleted"}
      {:ok, %{stats: %{"nodes-deleted" => 1}}} ->
        {:ok, "Deleted 1 node of type #{node_type_string}"}
      {:ok, %{stats: %{"nodes-deleted" => count}}} ->
        {:ok, "Deleted #{count} node of type #{node_type_string}"}
    end
  end

  def create_changeset_to_string(changeset) do
    changeset.changes
    |> Enum.map(fn {key, value} -> "#{key}: #{property_from_value(value)}" end)
    |> Enum.join(", ")
  end

  def update_create_changeset_to_string(changeset, node_var) do
    changeset.changes
    |> Enum.map(fn {key, value} -> "#{node_var}.#{key}=#{property_from_value(value)}" end)
    |> Enum.join(", ")
  end

end
