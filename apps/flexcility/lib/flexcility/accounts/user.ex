defmodule Flexcility.Accounts.User do
  # defstruct [:email, :name, :password, :uuid, :id]
  use Ecto.Schema

  schema "accounts_users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :password_confirmation, :string

    timestamps()
  end
end

