require IEx
defmodule Dobar.Public.PlaceController do
  use Dobar.Web, :controller

  alias Dobar.{Repo, Place, UserPlaceReview, City}

  plug :load_cities when action in [:index]

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

  defp filter_city(query, city_id) do
    if city_id do
      city = Repo.get!(City, city_id)
      
      query 
        |> Place.within_distance(city.lat, city.lon, city.area)
    else
      query
    end
  end

  defp filter_categories(query, params) do
    if params["categories"] do
      query 
        |> Place.by_category(params["categories"])
    else
      query
    end
  end

  defp search_by_name(query, params) do
    if params["term"] do
      query
        |> Place.with_name(params["term"])
    else
      query
    end
  end

  defp filter_by_location(query, params) do
    if params["lat"] && params["lon"] do
      query |> Place.within_distance(params["lat"], params["lon"])
    end
  end
end