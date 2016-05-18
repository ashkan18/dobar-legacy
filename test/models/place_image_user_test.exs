defmodule Dobar.PlaceImageUserTest do
  use Dobar.ModelCase

  alias Dobar.PlaceImageUser

  @valid_attrs %{url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlaceImageUser.changeset(%PlaceImageUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PlaceImageUser.changeset(%PlaceImageUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
