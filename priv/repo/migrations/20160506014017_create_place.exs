defmodule Dobar.Repo.Migrations.CreatePlace do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :short_description, :string
      add :description, :string
      add :geom, :geometry
      add :address, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :postal_code, :string
      add :go, :integer, defult: 0
      add :nogo, :integer, default: 0

      timestamps
    end

  end
end
