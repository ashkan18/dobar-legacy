defmodule Dobar.Repo.Migrations.AddUniqueIndexToReviewTable do
  use Ecto.Migration

  def change do
  	create index(:user_place_reviews, [:user_id, :place_id], unique: true)
  end
end
