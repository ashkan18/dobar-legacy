defmodule Dobar.Repo.Migrations.CreateUserPlaceReview do
  use Ecto.Migration

  def change do
    create table(:user_place_reviews) do
      add :go, :boolean, default: false
      add :comment, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :place_id, references(:places, on_delete: :nothing)

      timestamps
    end
    create index(:user_place_reviews, [:user_id])
    create index(:user_place_reviews, [:place_id])

  end
end
