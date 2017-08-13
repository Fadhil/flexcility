defmodule Flexcility.Web.UserController do
  use Flexcility.Web, :controller

  alias Flexcility.Accounts
  alias Flexcility.Accounts.User

  action_fallback Flexcility.Web.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, [%{"new_user"=> new_user}]} <- Accounts.create_user(user_params) do
      {:ok, [%{"user"=>user}]} =
        Accounts.get_user_by_email(%{email: new_user.properties["email"]})
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user.properties["uuid"]))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user!(id) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %{"new_user"=>user}} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user.properties)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
