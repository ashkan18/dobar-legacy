import IEx
defmodule Dobar.Api.V1.UserPlaceReviewController do
  use Dobar.Web, :controller

  alias Dobar.UserPlaceReview
  alias Dobar.Place

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.Api.V1.SessionController, :permission_denied } }

  def create(conn, %{"place_id" => place_id, "go" => go, "comment" => comment}) do
    # check to see if user has already reviewed this place
    user = Guardian.Plug.current_resource(conn)
    place = Repo.get!(Place, place_id)
    if Repo.get_by(UserPlaceReview, %{user_id: user.id, place_id: place_id}) do
      conn
        |> put_status(400)
        |> json(%{error: "existing_review"})
    else
      changeset = UserPlaceReview.changeset(%UserPlaceReview{}, %{user_id: user.id, place_id: place_id, go: go, comment: comment})
      case Repo.insert(changeset) do
        {:ok, user_place_review} ->
          # update go/nogo count on place
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
          json(conn, %{changeset: changeset})
      end
    end
  end
end