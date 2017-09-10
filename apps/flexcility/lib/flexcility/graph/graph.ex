defmodule Flexcility.Graph do
  alias Bolt.Sips, as: Bolt

  alias Flexcility.Utils
  import Flexcility.Graph.Property

  def create_node(resource, changeset) do
    attributes_string = create_changeset_to_string(changeset)
    resource_string = resource.__schema__(:source)
    query = """
      MERGE (id:UniqueId {name: '#{resource_string}'})
      ON CREATE SET id.count = 1
      ON MATCH SET id.count = id.count + 1
      WITH id.count AS uid
      MERGE (n:#{resource_string} {id: uid, #{attributes_string}})
      RETURN n as #{resource_string |> String.downcase}
    """

    case Bolt.query(Bolt.conn, query) do
      {:ok, [item]} ->
        {:ok, item |> Utils.get_struct(resource)}
      {:error, message} ->
        {:error, message}
    end
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

  def create_nodes_with_rel({node1, rel, node2}) do
    node1_attributes_string = create_changeset_to_string(node1)
    node2_attributes_string = create_changeset_to_string(node2)
    [node1_string, node2_string] = [node1, node2]
                                   |> Utils.get_schema_source_for_each()
    node1_string_downcased = node1_string
                             |> String.downcase
    node2_string_downcased = node2_string
                             |> String.downcase

    query = """
      MERGE (id:UniqueId {name: '#{node1_string}'})
      ON CREATE SET id.count = 1
      WITH id AS uid
      MERGE (n1:#{node1_string} {#{node1_attributes_string}})
      ON CREATE SET uid.count = uid.count + 1, n1.id = uid.count
      WITH n1
      MERGE (id2:UniqueId {name: '#{node2_string}'})
      ON CREATE SET id2.count = 1
      WITH n1, id2 as uid2
      MERGE (n2:#{node2_string} {#{node2_attributes_string}})
      ON CREATE SET uid2.count = uid2.count + 1, n2.id = uid2.count
      WITH n1, n2
      MERGE (n1)-[r:#{rel}]->(n2)
      return n1 as #{node1_string |> String.downcase}, n2 as #{node2_string |> String.downcase}, r as rel
    """

    case run_query(query) do
      {:ok, [items]} ->
        node_types_list = [
          {node1_string_downcased, node1.data.__struct__},
          {node2_string_downcased, node2.data.__struct__}
        ]
        node_types_list
        |> Enum.map(fn({_x,y}) -> Utils.get_struct(items, y) end)
      {:error, error_message} ->
        {:error, error_message}
    end
  end



  def run_query(query) do
    case Bolt.query(Bolt.conn, query) do
      {:ok, []} ->
        {:error, :no_matching_nodes_found}
      {:ok, results} ->
        {:ok, results}
      {:error, error_message} ->
        {:error, error_message}
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
