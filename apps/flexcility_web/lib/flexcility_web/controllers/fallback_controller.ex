defmodule Flexcility.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Flexcility.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Flexcility.Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error,
   [code: "Neo.ClientError.Schema.ConstraintValidationFailed",
    message: message ]}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Flexcility.Web.ErrorView, "error.json", error: %{email: "not unique"})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(Flexcility.Web.ErrorView, :"404")
  end
end
