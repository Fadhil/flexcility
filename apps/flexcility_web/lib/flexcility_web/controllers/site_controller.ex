defmodule Flexcility.Web.SiteController do
  use Flexcility.Web, :controller

  alias Flexcility.Admin
  alias Flexcility.Admin.Site

  action_fallback Flexcility.Web.FallbackController

  def index(conn, _params) do
    with {:ok, sites} <- Admin.list_sites() do
      render(conn, "index.json", sites: sites)
    end
  end

  def create(conn, %{"site" => site_params}) do
    with {:ok, %Site{} = site} <- Admin.create_site(site_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", site_path(conn, :show, site))
      |> render("show.json", site: site)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, site} <- Admin.get_site!(id) do
      render(conn, "show.json", site: site)
    end
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    site = Admin.get_site!(id)

    with {:ok, %Site{} = site} <- Admin.update_site(site, site_params) do
      render(conn, "show.json", site: site)
    end
  end

  def delete(conn, %{"id" => id}) do
    site = Admin.get_site!(id)
    with {:ok, %Site{}} <- Admin.delete_site(site) do
      send_resp(conn, :no_content, "")
    end
  end
end