defmodule Flexcility.Web.Router do
  use Flexcility.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Flexcility.Web do
    pipe_through :api
  end
end
