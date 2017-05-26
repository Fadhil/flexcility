defmodule Flexcility.Web.Repo.Migrations.CreateFlexcility.Web.Accounts.Session do
  use Ecto.Migration

  def change do
    create table(:accounts_sessions) do
      add :email, :string
      add :password, :string

      timestamps()
    end

  end
end
