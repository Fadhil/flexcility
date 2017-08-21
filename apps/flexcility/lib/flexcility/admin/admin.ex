defmodule Flexcility.Admin do
  @moduledoc """
  The boundary for the Admin system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias Flexcility.Admin.Site
  alias Flexcility.Graph
  alias Graph, as: Repo
  alias Flexcility.Utils

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Repo.all(Site)
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site(id) do
    case Graph.get_node_by_id(Site, id) do
      {:ok, []} ->
        {:error, "Site does not exist"}
      {:ok, site} ->
        {:ok, site |> Utils.get_struct(Site)}
    end
  end

  def get_site!(id) do
    case get_site(id) do
      {:ok, site} ->
        site
      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    cs = %Site{}
    |> site_changeset(attrs)

    case cs.valid? do
      true ->
        Graph.create_node(Site, cs)
      false ->
        {:error, cs}
    end
    # |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> site_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{source: %Site{}}

  """
  def change_site(%Site{} = site) do
    site_changeset(site, %{})
  end

  defp site_changeset(%Site{} = site, attrs) do
    site
    |> cast(attrs, [:name, :address, :description, :image])
    |> validate_required([:name, :address, :description])
  end
end
