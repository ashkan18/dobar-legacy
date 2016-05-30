defmodule Dobar.City do
  use Dobar.Web, :model

  schema "cities" do
    field :name, :string
    field :lat, :float
    field :lon, :float
    field :area, :integer
    field :enabaled, :boolean, default: false

    timestamps
  end

  @required_fields ~w(name lat lon area enabaled)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def alphabetical(query) do
    from c in query, order_by: c.name
  end 
end
