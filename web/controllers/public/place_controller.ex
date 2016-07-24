require IEx
defmodule Dobar.Public.PlaceController do
  use Dobar.Web, :controller

  alias Dobar.{Repo, Place, UserPlaceReview, City}

  def index(conn, params) do
    places = Place
              |> filter_city(params["city_id"])
              |> filter_by_location(params["search"])
              |> filter_categories(params["categories"])
              |> search_by_name(params["search"])
              |> Repo.all
              |> Repo.preload([:images, :user_reviews])
    conn
      |> assign(:places, places)
      |> render("index.html")
  end
  
  def show(conn, %{"id" => id}) do
    place = Repo.get(Place, id)
              |> Repo.preload([:images, :user_reviews])
    changeset = UserPlaceReview.changeset(%UserPlaceReview{})
    conn
      |> assign(:place, place)
      |> assign(:changeset, changeset)
      |> render("show.html")
  end

  defp load_cities(conn, _) do
    cities = City
              |> City.alphabetical
              |> Repo.all
    assign(conn, :cities, cities) 
  end

  defp filter_city(query, nil), do: query
  defp filter_city(query, city_id) do
    city = Repo.get!(City, city_id)
    query 
      |> Place.within_distance(city.lat, city.lon, city.area)
  end

  defp filter_categories(query, %{"categories" => categories}), do: Place.by_category(query, categories)
  defp filter_categories(query, _), do: query

  defp search_by_name(query, %{"term" => term}) when term != "", do: Place.with_name(query, term)
  defp search_by_name(query, _), do: query

  defp filter_by_location(query, %{"lat" => lat, "lon" => lon}), do: Place.within_distance(query, lat, lon)
  defp filter_by_location(query, _), do: query
end