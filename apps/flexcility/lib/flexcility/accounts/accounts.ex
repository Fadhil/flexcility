defmodule Flexcility.Accounts do
  import Ecto.Changeset

  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Flexcility.Accounts.User
  alias Flexcility.Accounts.Sessions
  alias Flexcility.Accounts.Organisation
  alias Flexcility.Accounts.Registration
  alias Flexcility.Graph
  alias Flexcility.Graph.Query
  alias Flexcility.Utils
  alias Bolt.Sips, as: Bolt
  @doc """
  Returns the list of users.

  ## Examples
      #
      # iex> list_users()
      # [%User{}, ...]
      #
  """
  def list_users do
    Graph.all(User)
  end

  @doc """
  Gets a single user.

  ## Examples
      #
      # iex> get_user!(123)
      # {:ok, user}
      #
      # iex> get_user!(456)
      # {:error, :user_not_found}

  """
  def get_user(id) do
    Graph.get(User, id)
  end

  def get_user!(id) do
    Graph.get!(User, id)
  end

  @doc """
  Gets a User by email

  ## Examples

      # iex> get_user_by_email(%{email: value})
      # {:ok, %{"user"=> user} }

  """
  def get_user_by_email(%{email: email}) do
    query = """
    MATCH (n:User {email: '#{email}'}) RETURN n as user
    """

    case Bolt.query(Bolt.conn, query) do
      {:ok, []} ->
        {:error, :user_not_found}
      {:ok, [user|_]} ->
        {:ok, user |> Utils.get_struct(User)}
    end
  end

  def get_user_by_email!(%{email: email}) do
    case get_user_by_email(%{email: email}) do
      {:ok, user} ->
        user
      {:error, :user_not_found} ->
        nil
    end
  end

  def get_user_by_email_and_org(%{email: email, subdomain: subdomain}) do
    query =
      %Query{}
      |> Query.match(%User{email: email})
  end

  def get_organisation(id) do
    Graph.get(Organisation, id)
  end

  def get_organisation!(id) do
    Graph.get!(Organisation, id)
  end

  def list_organisations do
    Graph.all(Organisation)
  end

  def create_organisation(org_attrs \\ %{}) do
    cs =
      %Organisation{}
      |> organisation_changeset(org_attrs)

    case cs.valid? do
      true ->
        Graph.create_node(Organisation, cs)
      false ->
        {:error, cs}
    end
  end

  def get_user_with_role_by_email(%{email: email, org_subdomain: org_subdomain}) do
    query = """
      MATCH (user:User {email: '#{email}'})-[rel]-(org:Organisation {subdomain: '#{org_subdomain}'})
      RETURN user, labels(rel) as role
    """

    Graph.run_query(query)
  end

  def register_user_with_org(registration_params, org_params) do
    reg_cs =
      %Registration{}
      |> registration_changeset(registration_params)

    org_cs =
      %Organisation{}
      |> organisation_changeset(org_params)

    case reg_cs.valid? and org_cs.valid? do
      true ->
        reg_cs = reg_cs
                  |> put_change(:password_hash,
                                Comeonin.Bcrypt.hashpwsalt(
                                  reg_cs.changes.password
                                )
                              )
                  |> delete_change(:password)
        query =
          %Query{}
          |> Query.unique_id(User)
          |> Query.with("id")
          |> Query.merge_with_id(reg_cs)
          |> Query.with("user")
          |> Query.unique_id(Organisation)
          |> Query.with(["user","id"])
          |> Query.merge_with_id(org_cs)
          |> Query.with(["user", "organisation"])
          |> Query.raw("MERGE (user)-[rel:OWNS]->(organisation)")
          |> Query.raw("MERGE (user)-[rel2:MEMBER {role: 'Admin'}]->(organisation)")
          |> Query.return([User, Organisation])

        Graph.run_query(query)
        # query = Graph.create_nodes_with_rel({reg_cs, "OWNS", org_cs})

      false ->
        {:error, [reg_cs, org_cs]}
    end
  end

  def register_user(attrs \\ %{}) do
    cs = %Registration{}
    |> registration_changeset(attrs)

    case cs.valid? do
      true ->
        cs = cs
              |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(cs.changes.password))
              |> delete_change(:password)
        Graph.create_node(User, cs)
      false ->
        {:error, cs}
    end
  end

  @doc """
  Creates a user.

  # ## Examples
  #
  #     iex> create_user(%{field: value})
  #     {:ok, %User{}}
  #
  #     iex> create_user(%{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    cs = %User{}
    |> user_changeset(attrs)

    case cs.valid? do
      true ->
        cs = cs
              |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(cs.changes.password))
              |> delete_change(:password)
        Graph.create_node(User, cs)
      false ->
        {:error, cs}
    end
		# query = """
		# 	CREATE (n:User {email: '#{email}', name: '#{name}', password: '#{password}'})
		# 	RETURN n as new_user
		# """

		# Graph.query(Graph.conn, query)
  end

  @doc """
  Updates a user.

  ## Examples
      #
      # iex> update_user(user, %{field: new_value})
      # {:ok, %User{}}
      #
      # iex> update_user(user, %{field: bad_value})
      # {:error, %Ecto.Changeset{}}

  """
  def update_user(user, attrs) do
    user
    # |> user_changeset(attrs)
    # |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples
      #
      # iex> delete_user(user)
      # {:ok, %User{}}
      #
      # iex> delete_user(user)
      # {:error, %Ecto.Changeset{}}

  """
  def delete_user(user) do
    Graph.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  # ## Examples
  #
  #     iex> change_user(user)
  #     %Ecto.Changeset{source: %User{}}

  """
  def change_user(user) do
    user_changeset(user, %{})
  end

  def change_organisation(organisation) do
    organisation_changeset(organisation, %{})
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
  end

  def user_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end

  def user_update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email])
  end

  def organisation_changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name, :location, :description, :subdomain])
    |> validate_required([:name, :subdomain])
  end

  def create_session(%{"email" => email, "password" => password}) do
    subdomain = "jkr"
    case Sessions.get_user_with_role(%{email: email, subdomain: subdomain})  do
      %{user: user, role: role} ->
        check_user_password({user, password, role})
      {:error, :no_matching_nodes_found} ->
        {:error, "Invalid Username/Password"}
    end
  end

  def create_session(%{error: :no_matching_nodes_found}) do
    dummy_checkpw()
    {:error, "Invalid Username/Password"}
  end

  def check_user_password({user, password, role}) do
    cond do
      user && checkpw(password, user.password_hash) ->
        token = Phoenix.Token.sign(Flexcility.Web.Endpoint, "user", user.id)
        session_data = %{user: user, role: role, token: token}
        {:ok, session_data}
      user ->
        {:error, "Invalid Username/Password"}
      true ->
        dummy_checkpw()
        {:error, "Invalid Username/Password"}
    end
  end
end
