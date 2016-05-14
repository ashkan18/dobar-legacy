defmodule Dobar.Repo.Migrations.EmbedManyCategoriesInPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :categories, { :array, :map }, default: []
    end
  end
end
