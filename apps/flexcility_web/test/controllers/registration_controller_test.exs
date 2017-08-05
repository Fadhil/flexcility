defmodule Flexcility.Web.RegistrationControllerTest do
  # use Flexcility.Web.ConnCase
  #
  # alias Flexcility.Web.Accounts
  # alias Flexcility.Web.Accounts.Registration
  #
  # @create_attrs %{email: "some email", name: "some name", password: "some password"}
  # @update_attrs %{email: "some updated email", name: "some updated name", password: "some updated password"}
  # @invalid_attrs %{email: nil, name: nil, password: nil}
  #
  # def fixture(:registration) do
  #   {:ok, registration} = Web.Accounts.create_registration(@create_attrs)
  #   registration
  # end
  #
  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, registration_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end
  #
  # test "creates registration and renders registration when data is valid", %{conn: conn} do
  #   conn = post conn, registration_path(conn, :create), registration: @create_attrs
  #   assert %{"id" => id} = json_response(conn, 201)["data"]
  #
  #   conn = get conn, registration_path(conn, :show, id)
  #   assert json_response(conn, 200)["data"] == %{
  #     "id" => id,
  #     "email" => "some email",
  #     "name" => "some name",
  #     "password" => "some password"}
  # end
  #
  # test "does not create registration and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, registration_path(conn, :create), registration: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "updates chosen registration and renders registration when data is valid", %{conn: conn} do
  #   %Registration{id: id} = registration = fixture(:registration)
  #   conn = put conn, registration_path(conn, :update, registration), registration: @update_attrs
  #   assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #   conn = get conn, registration_path(conn, :show, id)
  #   assert json_response(conn, 200)["data"] == %{
  #     "id" => id,
  #     "email" => "some updated email",
  #     "name" => "some updated name",
  #     "password" => "some updated password"}
  # end
  #
  # test "does not update chosen registration and renders errors when data is invalid", %{conn: conn} do
  #   registration = fixture(:registration)
  #   conn = put conn, registration_path(conn, :update, registration), registration: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "deletes chosen registration", %{conn: conn} do
  #   registration = fixture(:registration)
  #   conn = delete conn, registration_path(conn, :delete, registration)
  #   assert response(conn, 204)
  #   assert_error_sent 404, fn ->
  #     get conn, registration_path(conn, :show, registration)
  #   end
  # end
end
