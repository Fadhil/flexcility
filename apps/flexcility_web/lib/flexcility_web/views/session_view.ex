defmodule Flexcility.Web.SessionView do
  use Flexcility.Web, :view
  alias Flexcility.Web.SessionView

  def render("show.json", %{session: session}) do
    %{
      success: true,
      data: render_one(session, SessionView, "session.json")
    }
  end

  def render("session.json", %{session: session}) do
    %{id: session.user.id,
      email: session.user.email,
      role: session.role[:name],
      token: session.token}
  end
end
