defmodule Flexcility.Web.AccountsTest do
  use Flexcility.Web.DataCase

  alias Flexcility.Web.Accounts
  alias Flexcility.Web.Accounts.User

  @create_attrs %{email: "some email", name: "some name", password: "some password", password_confirmation: "some password_confirmation"}
  @update_attrs %{email: "some updated email", name: "some updated name", password: "some updated password", password_confirmation: "some updated password_confirmation"}
  @invalid_attrs %{email: nil, name: nil, password: nil, password_confirmation: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Web.Accounts.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Web.Accounts.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Web.Accounts.get_user!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Web.Accounts.create_user(@create_attrs)
    assert user.email == "some email"
    assert user.name == "some name"
    assert user.password == "some password"
    assert user.password_confirmation == "some password_confirmation"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Web.Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Web.Accounts.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.email == "some updated email"
    assert user.name == "some updated name"
    assert user.password == "some updated password"
    assert user.password_confirmation == "some updated password_confirmation"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Web.Accounts.update_user(user, @invalid_attrs)
    assert user == Web.Accounts.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Web.Accounts.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Web.Accounts.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Web.Accounts.change_user(user)
  end
end
