defmodule Dobar.Public.PlaceController do
  use Dobar.Web, :controller

  alias Dobar.{Repo, Place}

  def index(conn, _params) do
    places = Repo.all(Place)
              |> Repo.preload([:images, :user_reviews])
    conn
      |> assign(:places, places)
      |> render("index.html")
  end
  
  def show(conn, %{"id" => id}) do
    place = Repo.get(Place, id)
              |> Repo.preload([:images, :user_reviews])
    conn
      |> assign(:place, place)
      |> render("show.html")
  end
end