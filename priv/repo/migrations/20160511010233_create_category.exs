defmodule Dobar.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string

      timestamps
    end
    create index(:categories, [:name], unique: true)
  end
end
