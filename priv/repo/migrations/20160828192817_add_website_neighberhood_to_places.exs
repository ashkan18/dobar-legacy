defmodule Dobar.Repo.Migrations.AddWebsiteNeighberhoodToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :website, :string
      add :neighborhood, :string
      add :price_range, :integer
    end
  end
end
