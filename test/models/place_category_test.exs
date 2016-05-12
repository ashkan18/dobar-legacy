defmodule Dobar.PlaceCategoryTest do
  use Dobar.ModelCase

  alias Dobar.PlaceCategory

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlaceCategory.changeset(%PlaceCategory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PlaceCategory.changeset(%PlaceCategory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
