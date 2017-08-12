defmodule Flexcility.Admin.Site do
  use Ecto.Schema

  embedded_schema do
    field :address, :string
    field :description, :string
    field :image, :string
    field :name, :string

    timestamps()
  end
end
