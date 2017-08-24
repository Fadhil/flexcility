defmodule Flexcility.Accounts.Organisation do
  use Ecto.Schema

  schema "Organisation" do
    field :name, :string
    field :location, :string
    field :description, :string
  end
end
