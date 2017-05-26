defmodule Flexcility.Web.SessionController do
  use Flexcility.Web, :controller

  alias Flexcility.Accounts

  action_fallback Flexcility.Web.FallbackController

  def create(conn, %{"email" => email, "password" => password} = session_params) do
    with {:ok, user_with_role} <- Accounts.create_session(session_params) do
      conn
      |> put_status(:created)
      |> render("show.json", session: user_with_role)
    end
  end

  def delete(conn, %{"id" => id}) do
    session = Accounts.get_session!(id)
    with {:ok, %{}} <- Accounts.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end
end
