defmodule Flexcility.Web.SiteView do
  use Flexcility.Web, :view
  alias Flexcility.Web.SiteView

  def render("index.json", %{sites: sites}) do
    %{data: render_many(sites, SiteView, "site.json")}
  end

  def render("show.json", %{site: site}) do
    %{data: render_one(site, SiteView, "site.json")}
  end

  def render("site.json", %{site: site}) do
    %{id: site.id,
      name: site.name,
      address: site.address,
      description: site.description,
      image: site.image}
  end
end
