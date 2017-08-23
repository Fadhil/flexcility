defmodule Flexcility.Web.RegistrationController do
  use Flexcility.Web, :controller

  alias Flexcility.Accounts
  alias Flexcility.Accounts.User

  action_fallback Flexcility.Web.FallbackController

  def create(conn, %{"registration" => registration_params}) do
    with {:ok, %User{} = registration} <- Accounts.create_user(registration_params) do
      conn
      |> put_status(:created)
      |> render("show.json", registration: registration)
    end
  end
end
