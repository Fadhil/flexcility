defmodule Flexcility.Web.RegistrationController do
  use Flexcility.Web, :controller
  alias Flexcility.Accounts
  alias Accounts.{Registration, Organisation}

  action_fallback Flexcility.Web.FallbackController

  def create(conn, %{"user" => registration_params}) do
    org_params = %{
      "name" => "JKR", "location" => "Wilayah Persekutuan", "address" => "KL", "subdomain" => "jkr"
    }
    with {:ok, [registration = %Registration{}, organisation = %Organisation{}]} <- Accounts.register_user_with_org(
     registration_params, org_params
    ) do
      conn
      |> put_status(:created)
      |> render("show.json", registration: registration)
    end
  end
end
