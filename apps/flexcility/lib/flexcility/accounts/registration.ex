defmodule Flexcility.Accounts.Registration do

  use Ecto.Schema

  embedded_schema do
    field :name, :string
    field :email, :string
    field :password, :string
  end
end
