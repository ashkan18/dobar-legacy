defmodule Dobar.Repo.Migrations.AddNotesToPlaceImageUser do
  use Ecto.Migration

  def change do
    alter table(:place_image_users) do
      add :notes, :string
    end
  end
end
