defmodule Flexcility.Graph.Query do
  defstruct node_count: 0, string: "", returns: []

  alias Flexcility.Utils
  import Flexcility.Graph.Property
  alias Flexcility.Graph.Query

  def create(current_query, cs, node_var \\ nil) do
    node_var = get_node_var(cs, node_var)
    nc = node_count = current_query.node_count + 1
    query_string = """
      MERGE (id#{nc}:UniqueId {name: '#{node_name(cs)}'})
      ON CREATE SET id#{nc}.count = 1
      ON MATCH SET id#{nc}.count = id#{nc}.count + 1
      WITH id#{nc}
      CREATE (#{node_var}:#{node_label(cs)} {#{attributes_from_changeset(cs)}, id: id#{nc}.count})
    """

    %{current_query |
     string: current_query.string <> " " <> query_string,
    node_count: current_query.node_count + 1
     }
  end

  def get_node_var(resource, %{} = opts) do
    case Map.keys(opts) |> Enum.member?(:node_var) do
      true ->
        opts.node_var
      false ->
        node_name(resource)
    end
  end

  def get_node_var(resource, node_var \\ "") do
    case node_var do
      "" ->
       node_name(resource)
      nv ->
        nv
    end
  end

  def get_optional(%{}=opts) do
    case Map.keys(opts) |> Enum.member?(:optional) do
      true ->
        case opts.optional do
          true ->
            "OPTIONAL"
          false ->
            ""
        end
      false ->
        ""
    end
  end

  @spec match(%Query{}, map, string, map) :: %Query{}
  def match(current_query, res_a, rel, res_b)
    when is_map(res_a) and is_map(res_b) do
    query_string = """
      MATCH (#{get_node_var(res_a)}:#{node_label(res_a)} {#{attributes_from_struct(res_a)}})
      MATCH (#{get_node_var(res_b)}:#{node_label(res_b)} {#{attributes_from_struct(res_b)}})
      WITH #{get_node_var(res_a)}, #{get_node_var(res_b)}
      MATCH (#{get_node_var(res_a)})-[rel:#{rel}]->(#{get_node_var(res_b)})
    """

    current_query
    |> append(query_string)
  end

  @spec match(%Query{}, atom, map, map) :: %Query{}
  def match(current_query, resource, attrs, opts\\ %{})
    when is_atom(resource) and is_map(attrs) do
    node_var = get_node_var(resource, opts)
    optional = get_optional(opts)
    query_string = """
    #{optional} MATCH (#{node_var}:#{node_label(resource)} {#{attributes_from_map(attrs)}})
    """

    current_query
    |> append(query_string)
  end

  def raw(current_query, match_string)
    when is_bitstring match_string do

    query_string = """
      #{match_string}
    """
    current_query
    |> append(query_string)
  end

  def merge(current_query, cs, node_var \\ "") do
    node_var = get_node_var(cs, node_var)
    nc = node_count = current_query.node_count + 1
    query_string = """
      MERGE (id#{nc}:UniqueId {name: '#{node_label(cs)}'})
      ON CREATE SET id#{nc}.count = 1
      WITH id#{nc} AS uid#{nc}
      MERGE (#{node_var}:#{node_label(cs)} {#{attributes_from_changeset(cs)}})
      ON CREATE SET uid#{nc}.count = uid#{nc}.count + 1, #{node_var}.id = uid#{nc}.count
      WITH #{node_name(cs)}
    """

    %{current_query |
     string: current_query.string<> " " <> query_string,
     node_count: current_query.node_count + 1
     }
  end

  def merge_with_id(%Query{}=query, changeset, node_var \\ "") do
    node_var = get_node_var(changeset, node_var)
    query_string = """
      MERGE (#{node_var}:#{node_label(changeset)} {#{attributes_from_changeset(changeset)}})
      ON CREATE SET id.count = id.count + 1, #{node_var}.id = id.count
    """

    query
    |> append(query_string)
  end

  def unique_id(%Query{} = query, module) do
    node_label = Utils.GetSchema.source(module)
    query_string = """
      MERGE (id:UniqueId {name: '#{node_label}'})
      ON CREATE SET id.count = 1
    """

    query
    |> append(query_string)
  end

  def with(query, node_vars) when is_list node_vars do
    node_vars_string =
      node_vars
      |> Enum.join(", ")

    query_string = """
      WITH #{node_vars_string}
    """

    query
    |> append(query_string)
  end

  def with(query, node_var) when is_bitstring node_var do
    query_string = """
      WITH #{node_var}
    """

    query
    |> append(query_string)
  end

  def append(query, query_string) do
    %{query |
     string: query.string <> " " <> query_string
    }
  end

  def return(query, node_var \\ "")
  def return(current_query, node_var) when is_atom node_var do
    query_string = """
      RETURN #{node_var}
    """
    query =
      %{current_query |
        returns: [node_var]
      }

    query
    |> append(query_string)
  end

  def return(current_query, node_vars) when is_list node_vars do
    [head|tail] = node_vars
    node_vars_string = cond do
      is_atom(head) ->
        node_vars
        |> Enum.map(&(Utils.GetSchema.source(&1) |> String.downcase))
        |> Enum.join(", ")
    end

    query =
      %{current_query |
        returns: node_vars
     }

    query_string = """
      RETURN #{node_vars_string}
    """

    query
    |> append(query_string)
  end

  def attributes_from_changeset(changeset) do
    changeset.changes
    |> attributes_from_map
  end

  def attributes_from_map(attrs) do
    attrs
    |> Enum.map(fn {key, value} -> "#{key}: #{property_from_value(value)}" end)
    |> Enum.join(", ")
  end

  def attributes_from_struct(struct) do
    get_fields_from_struct(struct)
    |> Enum.reduce(%{}, fn(field, acc)-> Map.put(acc, field, Map.get(struct, field)) end)
    |> Enum.filter(fn({k,v})-> v != nil end)
    |> attributes_from_map
  end

  def get_fields_from_struct(module) when is_atom module do
    module.__schema__(:fields)
  end

  def get_fields_from_struct(struct) when is_map struct do
    struct.__struct__.__schema__(:fields)
  end

  def node_name(changeset) do
    changeset
    |> node_label
    |> String.downcase
  end

  def node_label(changeset) do
    changeset
    |> Utils.GetSchema.source
  end
end
