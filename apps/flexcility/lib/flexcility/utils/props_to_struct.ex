defmodule Flexcility.Utils.PropsToStruct do
  defmacro __using__(_) do
    quote do
      alias Ecto.Changeset

      def from_props(props) do
        __MODULE__.__struct__
        |> Changeset.cast(props, __MODULE__.__schema__(:fields))
        |> Changeset.apply_changes()
      end
    end
  end
end
