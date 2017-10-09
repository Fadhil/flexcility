defmodule Flexcility.Web.RegistrationView do
  use Flexcility.Web, :view
  alias Flexcility.Web.RegistrationView

  def render("index.json", %{users: users}) do
    %{success: true, data: render_many(users, RegistrationView, "registration.json")}
  end

  def render("show.json", %{user: user}) do
    %{success: true, data: render_one(user, RegistrationView, "registration.json")}
  end

  def render("registration.json", %{registration: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      }
  end
end
