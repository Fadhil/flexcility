defmodule Flexcility.Admin.Site do

  @all_fields [:name, :address, :description, :image]
  @required_fields [:name, :address, :description]

  use Ecto.Schema
  use Flexcility.Utils.PropsToStruct


  embedded_schema do
    field :address, :string
    field :description, :string
    field :image, :string
    field :name, :string
  end
end
