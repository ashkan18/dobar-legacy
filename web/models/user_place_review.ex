defmodule Dobar.UserPlaceReview do
  use Dobar.Web, :model

  @derive {Poison.Encoder, only: [:go, :comment]}
  
  schema "user_place_reviews" do
    field :go, :boolean, default: false
    field :comment, :string
    belongs_to :user, Dobar.User
    belongs_to :place, Dobar.Place

    timestamps
  end

  @required_fields ~w(go comment place_id user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:place_id)
    |> unique_constraint(:user_id_place_id)
  end
end
