defmodule Flexcility.Web.SiteController do
  use Flexcility.Web, :controller

  alias Flexcility.Admin
  alias Flexcility.Admin.Site

  action_fallback Flexcility.Web.FallbackController

  def index(conn, _params) do
    sites =  Admin.list_sites()
    render(conn, "index.json", sites: sites)
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
    with {:ok, site} <- Admin.get_site(id) do
      render(conn, "show.json", site: site)
    end
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    with {:ok, site} <- Admin.get_site(id) do
      with {:ok, %Site{} = site} <- Admin.update_site(site, site_params) do
        render(conn, "show.json", site: site)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, site} <- Admin.get_site(id) do
      with {:ok, message} <- Admin.delete_site(site) do
       render(conn, "delete.json", message: message)
      end
    end
  end
end
