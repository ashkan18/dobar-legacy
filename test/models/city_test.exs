defmodule Dobar.CityTest do
  use Dobar.ModelCase

  alias Dobar.City

  @valid_attrs %{area: 42, enabaled: true, lat: "120.5", lon: "120.5", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = City.changeset(%City{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = City.changeset(%City{}, @invalid_attrs)
    refute changeset.valid?
  end
end
