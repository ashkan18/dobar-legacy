defmodule Dobar.PlaceImageUser do
  use Dobar.Web, :model

  schema "place_image_users" do
    field :url, :string
    field :notes, :string
    field :upload_token, :string

    belongs_to :place, Dobar.Place
    belongs_to :user, Dobar.User

    timestamps
  end

  @required_fields ~w(url user_id place_id upload_token)
  @optional_fields ~w(notes)

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
  end
end
