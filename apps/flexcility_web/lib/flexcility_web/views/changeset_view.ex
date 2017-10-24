defmodule Flexcility.Web.ChangesetView do
  use Flexcility.Web, :view
  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `Flexcility.Web.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset),
      success: false
    }
  end

  def render("multiple_errors.json", %{changesets: [_head|_tail] = changesets}) do
    [errors] =
      changesets
      |> Enum.map(fn(x) -> translate_errors(x) end)
      |> Enum.filter(fn(x)-> x != %{} end)
      |> List.flatten

      #require IEx; IEx.pry()
    %{success: false,
      errors: errors
   }
  end
end
