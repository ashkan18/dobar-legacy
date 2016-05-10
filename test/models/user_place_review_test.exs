defmodule Dobar.UserPlaceReviewTest do
  use Dobar.ModelCase

  alias Dobar.UserPlaceReview

  @valid_attrs %{comment: "some content", go: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserPlaceReview.changeset(%UserPlaceReview{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserPlaceReview.changeset(%UserPlaceReview{}, @invalid_attrs)
    refute changeset.valid?
  end
end
