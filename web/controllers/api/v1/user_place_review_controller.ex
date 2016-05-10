import IEx
defmodule Dobar.Api.V1.UserPlaceReviewController do
  use Dobar.Web, :controller

  alias Dobar.UserPlaceReview
  alias Dobar.Place

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.Api.V1.SessionController, :permission_denied } }

  def create(conn, %{"place_id" => place_id, "go" => go, "comment" => comment}) do
    # check to see if user has already reviewed this place
    user = Guardian.Plug.current_resource(conn)
    changeset = UserPlaceReview.changeset(%UserPlaceReview{}, %{user_id: user.id, place_id: place_id, go: go, comment: comment})
    case Repo.insert(changeset) do
      {:ok, user_place_review} ->
        # update go/nogo count on place
        place = Repo.get!(Place, place_id)
        place_changeset = 
          case go do
            true -> Place.changeset(place, %{ go: place.go + 1 }  )
            false -> Place.changeset(place, %{ nogo: place.nogo + 1 })
          end
        Repo.update!(place_changeset)
        put_status(conn, 202)
        json(conn, user_place_review)
      {:error, changeset} ->
        put_status(conn, 400)
        json(conn, %{errors: Enum.into(changeset.errors, %{})})
    end
  end
end