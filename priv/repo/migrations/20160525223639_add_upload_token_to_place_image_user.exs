defmodule Dobar.Repo.Migrations.AddUploadTokenToPlaceImageUser do
  use Ecto.Migration

  def change do
    alter table (:place_image_users) do
      add :upload_token, :string
    end
  end
end
