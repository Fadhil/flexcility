defmodule Flexcility.Web.SessionView do
  use Flexcility.Web, :view
  alias Flexcility.Web.SessionView

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.user["uuid"],
      email: session.user["email"],
      role: session.role["name"],
      token: session.token}
  end
end
