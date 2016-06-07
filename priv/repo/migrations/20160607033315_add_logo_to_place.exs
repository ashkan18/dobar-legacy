defmodule Dobar.Repo.Migrations.AddLogoToPlace do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :logo, :string
    end
  end
end
