import IEx
defmodule Dobar.Api.V1.PlaceController do
  use Dobar.Web, :controller
  alias Dobar.Place

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.Api.V1.SessionController, :permission_denied } }

  def index(conn, %{"lat" => lat, "lon" => lon}) do
    results = Place
              |> Place.within_distance(lat, lon)
              |> Repo.all
    conn
      |> json(%{closest: results})
  end
end