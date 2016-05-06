defmodule Dobar.Repo.Migrations.CreatePlace do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :short_description, :string
      add :description, :string
      add :geom, :geometry
      add :go, :integer
      add :nogo, :integer

      timestamps
    end

  end
end
