defmodule Dobar.Repo.Migrations.CreatePlaceCategory do
  use Ecto.Migration

  def change do
    create table(:place_categories) do
      add :place_id, references(:places, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps
    end
    create index(:place_categories, [:place_id])
    create index(:place_categories, [:category_id])
    create index(:place_categories, [:place_id, :category_id], unique: true)
  end
end
