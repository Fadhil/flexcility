defmodule Flexcility.Accounts.Registration do

  use Ecto.Schema

  schema "User" do
    field :name, :string
    field :email, :string
    field :password, :string
  end
end
