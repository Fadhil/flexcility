defmodule Flexcility.Web.UserView do
  use Flexcility.Web, :view
  alias Flexcility.Web.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.properties["uuid"],
      name: user.properties["name"],
      email: user.properties["email"]#,
      #password: user.password,
      #password_confirmation: user.password_confirmation}
  }
  end
end
