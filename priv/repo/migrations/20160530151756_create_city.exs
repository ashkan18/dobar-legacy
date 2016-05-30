defmodule Dobar.Repo.Migrations.CreateCity do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :lat, :float
      add :lon, :float
      add :area, :integer
      add :enabaled, :boolean, default: false

      timestamps
    end

  end
end
