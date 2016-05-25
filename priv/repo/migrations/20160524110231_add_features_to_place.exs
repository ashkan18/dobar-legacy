defmodule Dobar.Repo.Migrations.AddFeaturesToPlace do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :delivery, :boolean
      add :card, :boolean
      add :wifi, :boolean
      add :outdoor_seating, :boolean
      add :takes_reservation, :boolean
      add :good_for_groups, :boolean
      add :weelchaire_accessible, :boolean
      add :smoking, :boolean
      add :parking, :boolean
    end
  end
end
