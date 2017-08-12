defmodule Flexcility.Web.SiteControllerTest do
  use Flexcility.Web.ConnCase

  alias Flexcility.Web.Admin
  alias Flexcility.Web.Admin.Site

  @create_attrs %{address: "some address", description: "some description", image: "some image", name: "some name"}
  @update_attrs %{address: "some updated address", description: "some updated description", image: "some updated image", name: "some updated name"}
  @invalid_attrs %{address: nil, description: nil, image: nil, name: nil}

  def fixture(:site) do
    {:ok, site} = Web.Admin.create_site(@create_attrs)
    site
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, site_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates site and renders site when data is valid", %{conn: conn} do
    conn = post conn, site_path(conn, :create), site: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, site_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "address" => "some address",
      "description" => "some description",
      "image" => "some image",
      "name" => "some name"}
  end

  test "does not create site and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, site_path(conn, :create), site: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen site and renders site when data is valid", %{conn: conn} do
    %Site{id: id} = site = fixture(:site)
    conn = put conn, site_path(conn, :update, site), site: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, site_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "address" => "some updated address",
      "description" => "some updated description",
      "image" => "some updated image",
      "name" => "some updated name"}
  end

  test "does not update chosen site and renders errors when data is invalid", %{conn: conn} do
    site = fixture(:site)
    conn = put conn, site_path(conn, :update, site), site: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen site", %{conn: conn} do
    site = fixture(:site)
    conn = delete conn, site_path(conn, :delete, site)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, site_path(conn, :show, site)
    end
  end
end
