defmodule Flexcility.Accounts.User do

  use Ecto.Schema

  schema "User" do
    field :name, :string
    field :email, :string
    field :image, :string
    field :password_hash, :string
    belongs_to :organisation, Flexcility.Accounts.Organisation
  end
end
