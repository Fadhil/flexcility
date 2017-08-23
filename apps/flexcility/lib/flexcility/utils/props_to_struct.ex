defmodule Flexcility.Utils.PropsToStruct do
  defmacro __using__(_) do
    quote do
      alias Ecto.Changeset

      def from_props(props) do
        __MODULE__.__struct__
        |> Changeset.cast(props, @all_fields)
        |> Changeset.validate_required(@required_fields)
        |> apply_id_from_props(props)
        |> Changeset.apply_changes()
      end

      defp apply_id_from_props(cs, props) do
        cs
        |> Changeset.change(%{id: props["id"]})
      end
    end
  end
end
