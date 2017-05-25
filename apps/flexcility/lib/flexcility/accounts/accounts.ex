defmodule Flexcility.Accounts do
  import Ecto.Changeset
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  # alias Flexcility.Repo

  alias Flexcility.Accounts.User

  alias Bolt.Sips, as: Graph


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do

    users = Graph.query!(Graph.conn, "MATCH (n:User) return n")
    |> Enum.map(fn( %{"n"=>user} ) -> map_to_struct(%User{}, user.properties) end)

  end

  defp map_to_struct(struct_, properties) do
    properties
    |> Enum.reduce(struct_, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    [head|tail] = Graph.query!(Graph.conn, "MATCH (n:User {uuid: '#{id}'}) return n")
    |> Enum.map(fn( %{"n"=>user} ) -> map_to_struct(%User{}, user.properties) end)
    head
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    # {:ok, %User{name: "Fadhil", email: "test@gmail.com", uuid: "test"}}

    user = %User{}
    |> user_changeset(attrs)
    # |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    # |> user_changeset(attrs)
    # |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    # Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  def user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
  end
end
