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
    message = case String.match?(message, ~r/Node\s\d+\salready\sexists.*email.*/) do
      true ->
        "Email has been taken"
      false ->
        message
    end
    conn
    |> put_status(:unprocessable_entity)
    |> render(Flexcility.Web.ErrorView, "error.json", error: message)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(Flexcility.Web.ErrorView, :"404")
  end

  def call(conn, {:error, error_message}) do
    conn
    |> render(Flexcility.Web.ErrorView, "error.json", error: error_message)
  end

end
