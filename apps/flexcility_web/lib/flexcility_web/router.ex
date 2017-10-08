defmodule Flexcility.Web.Router do
  use Flexcility.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :restricted_api do
    plug :accepts, ["json"]
    plug Flexcility.Web.Plugs.Authenticate
  end

  scope "/api", Flexcility.Web do
    pipe_through :api

    resources "/registration", RegistrationController, only: [:create]
    resources "/sessions", SessionController, only: [:create, :delete]
  end

  scope "/api", Flexcility.Web do
    pipe_through :restricted_api

    resources "/sites", SiteController
    # resources "/users", UserController
    get "/users/:email", UserController, :show
  end
end
