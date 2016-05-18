defmodule Dobar.Repo.Migrations.CreatePlaceImageUser do
  use Ecto.Migration

  def change do
    create table(:place_image_users) do
      add :url, :string
      add :place_id, references(:places, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:place_image_users, [:place_id])
    create index(:place_image_users, [:user_id])

  end
end
