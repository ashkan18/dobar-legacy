defmodule Dobar.Category do
  use Dobar.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "categories" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
