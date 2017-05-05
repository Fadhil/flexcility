defmodule Flexcility.Web.Repo.Migrations.CreateFlexcility.Web.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :password_confirmation, :string

      timestamps()
    end

  end
end
