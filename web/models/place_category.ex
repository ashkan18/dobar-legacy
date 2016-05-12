defmodule Dobar.PlaceCategory do
  use Dobar.Web, :model

  schema "place_categories" do
    belongs_to :place, Dobar.Place
    belongs_to :category, Dobar.Category

    timestamps
  end

  @required_fields ~w(place_id category_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:place_id)
    |> unique_constraint(:place_id_category_id)
  end
end
