defmodule Flexcility.Accounts.User do

  use Ecto.Schema

  schema "User" do
    field :name, :string
    field :email, :string
    field :image, :string
    field :password_hash, :string
    has_many :organisations, Flexcility.Accounts.Organisation
    has_many :roles, Flexcility.Accounts.Role
  end
end
