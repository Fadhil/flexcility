defmodule Flexcility.Accounts do
  import Ecto.Changeset
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  # alias Flexcility.Repo

  alias Flexcility.Accounts.User

  alias Bolt.Sips, as: Graph

  alias Flexcility.Graph.Node

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do

    users = Graph.query!(Graph.conn, "MATCH (n:User) return n")
    |> Enum.map(fn( %{"n"=>user} ) -> user end)

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
    [%{"n" => user }] = Graph.query!(Graph.conn, "MATCH (n:User {uuid: '#{id}'}) return n")
    #|> Enum.map(fn( %{"n"=>user} ) -> map_to_struct(%User{}, user.properties) end)
    user
  end

  @doc """
  Gets a User by email

  ## Examples

      iex> get_user_by_email(%{email: value})
      {:ok, %{"user"=> user} }

  """
  def get_user_by_email(%{email: email}) do
    query = """
    MATCH (n:User {email: '#{email}'}) RETURN n as user
    """

    Graph.query(Graph.conn, query)
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(%{"email"=>email, "name"=>name, "password"=>password} = attrs \\ %{}) do
		query = """
			CREATE (n:User {email: '#{email}', name: '#{name}', password: '#{password}'})
			RETURN n as new_user
		"""

		Graph.query(Graph.conn, query)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(user, attrs) do
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
  def delete_user(user) do
    # Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(user) do
    user_changeset(user, %{})
  end

  def user_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
  end

  def create_session(%{"email" => email, "password" => password}) do
    query = """
      MATCH (n:User {email: '#{email}', password: '#{password}' })
      OPTIONAL MATCH (n)-[:HAS_ROLE]->(r) return n, r
     """
    result =
      Graph.query!(
        Graph.conn, query
      )
    #|> Enum.map(fn( %{"n"=>user} ) -> map_to_struct(%User{}, user.properties) end)
    case result do
      [] -> {:error, "Invalid Username/Password"}
      [%{"n"=>user, "r"=>role}] -> {:ok, %{user: user.properties, role: role}}
    end
  end
end
