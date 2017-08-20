defmodule Flexcility.Utils do
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
    map
    |> get_properties(resource)
    |> resource.from_props
  end
end
