defmodule Dobar.Repo.Migrations.AddTelephoneWorkingHoursToPlaces do
  use Ecto.Migration

  def change do
    alter table (:places) do
      add :phone, :string
      add :working_hours, :string
    end
  end
end
