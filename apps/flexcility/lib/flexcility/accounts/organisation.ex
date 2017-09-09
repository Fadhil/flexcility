defmodule Flexcility.Accounts.Organisation do
  use Ecto.Schema

  schema "Organisation" do
    field :name, :string
    field :subdomain, :string
    field :location, :string
    field :description, :string
    has_many :sites, Flexcility.Admin.Site
  end
end
