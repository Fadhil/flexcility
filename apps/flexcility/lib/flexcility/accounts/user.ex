defmodule Flexcility.Accounts.User do

  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :image, :string
    field :password_hash, :string
    field :password, :string, virtual: true
  end
end
