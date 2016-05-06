defmodule Dobar.PlaceTest do
  use Dobar.ModelCase

  alias Dobar.Place

  @valid_attrs %{description: "some content", go: 42, name: "some content", nogo: 42, short_description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Place.changeset(%Place{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Place.changeset(%Place{}, @invalid_attrs)
    refute changeset.valid?
  end
end
