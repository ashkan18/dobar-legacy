import Geo.PostGIS
defmodule Dobar.Place do
  use Dobar.Web, :model
  import Ecto.Query
  alias Dobar.{Category, UserPlaceReview}

  @derive {Poison.Encoder, only: [:id, :name, :short_description, :description, :geom, :address, :address2, :city, :state, :country, :go, :nogo, :user_place_reviews]}
  
  schema "places" do
    field :name, :string
    field :short_description, :string
    field :description, :string
    field :geom, Geo.Point
    field :address, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :postal_code, :string
    field :go, :integer, default: 0
    field :nogo, :integer, default: 0
    field :type, :string, default: "restaurant"
    field :phone, :string
    field :working_hours, :string

    has_many :user_place_reviews, UserPlaceReview
    has_many :user_reviews, through: [:user_place_reviews, :user]

    embeds_many :categories, Category, on_replace: :delete
    timestamps
  end

  @place_types ~w(restaurant cafe)
  @required_fields ~w(name type short_description geom address address2 city state country)
  @optional_fields ~w(description go nogo categories phone working_hours)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    if params !== :empty && Map.has_key?(params, "lat") && Map.has_key?(params, "lon") do
      {lat, params } = Dict.pop(params, "lat") 
      {lon, params } = Dict.pop(params, "lon")
      params = Dict.put_new(params, "geom", %Geo.Point{ coordinates: { lat, lon }, srid: 4326 })
    end

    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, @place_types)
    |> cast_embed(:categories)
  end

  def within_distance(query, lat, lon, distance \\ 1) do
    point = %Geo.Point{ coordinates: {lat, lon}, srid: 4326}
    from place in query, where: st_dwithin(place.geom, ^point, ^distance), preload: :user_reviews
  end

  def paginate(query, page, size) do
    from query,
      limit: ^size,
      offset: ^((page-1) * size)
  end
end
