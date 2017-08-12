defmodule Flexcility.Web.AdminTest do
  use Flexcility.Web.DataCase

  alias Flexcility.Web.Admin
  alias Flexcility.Web.Admin.Site

  @create_attrs %{address: "some address", description: "some description", image: "some image", name: "some name"}
  @update_attrs %{address: "some updated address", description: "some updated description", image: "some updated image", name: "some updated name"}
  @invalid_attrs %{address: nil, description: nil, image: nil, name: nil}

  def fixture(:site, attrs \\ @create_attrs) do
    {:ok, site} = Web.Admin.create_site(attrs)
    site
  end

  test "list_sites/1 returns all sites" do
    site = fixture(:site)
    assert Web.Admin.list_sites() == [site]
  end

  test "get_site! returns the site with given id" do
    site = fixture(:site)
    assert Web.Admin.get_site!(site.id) == site
  end

  test "create_site/1 with valid data creates a site" do
    assert {:ok, %Site{} = site} = Web.Admin.create_site(@create_attrs)
    assert site.address == "some address"
    assert site.description == "some description"
    assert site.image == "some image"
    assert site.name == "some name"
  end

  test "create_site/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Web.Admin.create_site(@invalid_attrs)
  end

  test "update_site/2 with valid data updates the site" do
    site = fixture(:site)
    assert {:ok, site} = Web.Admin.update_site(site, @update_attrs)
    assert %Site{} = site
    assert site.address == "some updated address"
    assert site.description == "some updated description"
    assert site.image == "some updated image"
    assert site.name == "some updated name"
  end

  test "update_site/2 with invalid data returns error changeset" do
    site = fixture(:site)
    assert {:error, %Ecto.Changeset{}} = Web.Admin.update_site(site, @invalid_attrs)
    assert site == Web.Admin.get_site!(site.id)
  end

  test "delete_site/1 deletes the site" do
    site = fixture(:site)
    assert {:ok, %Site{}} = Web.Admin.delete_site(site)
    assert_raise Ecto.NoResultsError, fn -> Web.Admin.get_site!(site.id) end
  end

  test "change_site/1 returns a site changeset" do
    site = fixture(:site)
    assert %Ecto.Changeset{} = Web.Admin.change_site(site)
  end
end
