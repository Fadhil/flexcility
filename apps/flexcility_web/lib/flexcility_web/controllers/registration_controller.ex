defmodule Flexcility.Web.RegistrationController do
  use Flexcility.Web, :controller

  alias Flexcility.Accounts
  alias Flexcility.Accounts.Registration

  action_fallback Flexcility.Web.FallbackController

  def create(conn, %{"registration" => registration_params}) do
    with {:ok, %Registration{} = registration} <- Accounts.register(registration_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", registration_path(conn, :show, registration))
      |> render("show.json", registration: registration)
    end
  end
end
