defmodule Flexcility.Admin.Site do

  use Ecto.Schema

  schema "sites" do
    field :address, :string
    field :description, :string
    field :image, :string
    field :name, :string
  end
end
