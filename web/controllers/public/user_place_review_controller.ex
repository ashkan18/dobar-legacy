require IEx
defmodule Dobar.Public.UserPlaceReviewController do
  use Dobar.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.AuthenticationController, :permission_denied } }
  plug Dobar.Plug.Auth when action in [:create]
  

  alias Dobar.{Repo, UserPlaceReview, Place}

  
  def new(conn, _params) do
    changeset = UserPlaceReview.changeset(%UserPlaceReview{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"go" => go, "place_id" => place_id} = params["user_place_review"]
    user = Guardian.Plug.current_resource(conn)
    place = Repo.get!(Place, place_id)
    changeset = UserPlaceReview.changeset(%UserPlaceReview{}, %{user_id: user.id, place_id: place_id, go: go})
    case Repo.insert(changeset) do
      {:ok, user_place_review} ->
        # update go/nogo count on place
        place_changeset = 
          case go do
            "true" -> Place.changeset(place, %{ go: place.go + 1 }  )
            "false" -> Place.changeset(place, %{ nogo: place.nogo + 1 })
          end
        Repo.update!(place_changeset)
        conn
          |> put_flash(:info, "Opinion submitted successfully.")
          |> redirect(to: place_path(conn, :show, place))
      {:error, changeset} ->
        conn
          |> put_flash(:error, "You already have submitted your opinion.")
          |> redirect(to: place_path(conn, :show, place))
    end
  end
end