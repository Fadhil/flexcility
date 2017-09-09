defmodule Flexcility.Utils do
  alias Ecto.Changeset

  def get_resource_name(resource) do
    to_string(resource)
    |> String.split(".")
    |> List.last
  end

  @doc """
    Used to get the source name from an Ecto changeset or an Ecto Schema struct
  """
  defprotocol GetSchema do
    @fallback_to_any true
    def source(resource)
  end

  defimpl GetSchema, for: Ecto.Changeset do
    def source(changeset) do
      changeset.data.__struct__.__schema__(:source)
    end
  end

  defimpl GetSchema, for: Any do
    def source(resource) when is_map(resource) do
      case Map.has_key?(resource, :__struct__) do
        true ->
          resource.__struct__.__schema__(:source)
        false ->
          {:error, :not_implemented}
      end
    end

    def source(resource) do
      case resource.__info__(:functions)[:__schema__] do
        nil ->
          {:error, :no_source_found}
        arity ->
          resource.__schema__(:source)
      end
    end
  end

  def get_schema_source(resource) do
    GetSchema.source(resource)
  end

  def get_schema_source_for_each(list) do
    list |> Enum.map(&get_schema_source(&1))
  end

  def get_properties(map, resource) do
    resource_name = GetSchema.source(resource) |> String.downcase
    map["#{resource_name}"].properties
  end

  def get_struct(map, resource) do
    props = map
            |> get_properties(resource)

    resource.__struct__
    |> Changeset.cast(props, resource.__schema__(:fields))
    |> Changeset.apply_changes()
  end

  def get_struct_from_node(n) do
    props = n.properties

  end
end
