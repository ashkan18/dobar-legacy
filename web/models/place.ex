import Geo.PostGIS
defmodule Dobar.Place do
  use Dobar.Web, :model
  import Ecto.Query

  schema "places" do
    field :name, :string
    field :short_description, :string
    field :description, :string
    field :geom, Geo.Point
    field :go, :integer
    field :nogo, :integer

    timestamps
  end

  @required_fields ~w(name short_description geom)
  @optional_fields ~w(description)

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
  end

  def within_distanece(query, lat, lon, distance) do
    point = %Geo.Point{ coordinates: {lat, lon}, srid: 4326}
    from place in query, where: st_dwithin(place.geom, ^point, ^distance)
  end
end
