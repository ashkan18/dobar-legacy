defmodule Dobar.Repo.Migrations.AddLinksToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :instagram, :string
      add :facebook, :string
      add :twitter, :string
    end
  end
end
