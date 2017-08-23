defmodule Flexcility.Web.RegistrationView do
  use Flexcility.Web, :view
  alias Flexcility.Web.RegistrationView

  def render("index.json", %{users: users}) do
    %{success: true, data: render_many(users, RegistrationView, "registration.json")}
  end

  def render("show.json", %{registration: registration}) do
    %{success: true, data: render_one(registration, RegistrationView, "registration.json")}
  end

  def render("registration.json", %{registration: registration}) do
    %{id: registration.id,
      name: registration.name,
      email: registration.email,
      }
  end
end
