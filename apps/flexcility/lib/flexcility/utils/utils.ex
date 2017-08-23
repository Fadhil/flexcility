defmodule Flexcility.Utils do
  alias Ecto.Changeset

  def get_resource_name(resource) do
    to_string(resource)
    |> String.split(".")
    |> List.last
  end

  def get_properties(map, resource) do
    resource_name = get_resource_name(resource) |> String.downcase
    map["#{resource_name}"].properties
  end

  def get_struct(map, resource) do
    props = map
            |> get_properties(resource)

    resource.__struct__
    |> Changeset.cast(props, resource.__schema__(:fields))
    |> Changeset.apply_changes()
  end
end
