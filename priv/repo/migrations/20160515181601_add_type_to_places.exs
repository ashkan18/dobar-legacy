defmodule Dobar.Repo.Migrations.AddTypeToPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :type, :string, default: "restaurant"
    end
  end
end
