require IEx
defmodule Dobar.Admin.PlaceController do
  use Dobar.Web, :controller

  alias Dobar.Place
  alias Dobar.Category

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.Api.V1.SessionController, :permission_denied } }

  plug :scrub_params, "place" when action in [:create, :update]

  def index(conn, _params) do
    places = Repo.all(Place)
    render(conn, "index.html", places: places)
  end

  def new(conn, _params) do
    changeset = Place.changeset(%Place{})
    conn
      |> assign(:changeset, changeset)
      |> assign(:categories, Repo.all(Category))
      |> render("new.html")
  end

  def create(conn, %{"place" => place_params}) do
    # format categories to include name tag
    categories = Dict.get(place_params, "categories")
                  |> Enum.map(fn c -> %{name: c} end)
    place_params = Dict.merge(place_params, %{"categories" => categories})
    
    changeset = Place.changeset(%Place{}, place_params)
    case Repo.insert(changeset) do
      {:ok, _place} ->
        conn
          |> put_flash(:info, "Place created successfully.")
          |> redirect(to: place_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, categories: Repo.all(Category))
    end
  end

  def show(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)
    render(conn, "show.html", place: place)
  end

  def edit(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)
    changeset = Place.changeset(place)
    render(conn, "edit.html", place: place, changeset: changeset, categories: Repo.all(Category))
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Repo.get!(Place, id)
    changeset = Place.changeset(place, place_params)

    case Repo.update(changeset) do
      {:ok, place} ->
        conn
        |> put_flash(:info, "Place updated successfully.")
        |> redirect(to: place_path(conn, :show, place))
      {:error, changeset} ->
        render(conn, "edit.html", place: place, changeset: changeset, categories: Repo.all(Category))
    end
  end

  def delete(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(place)

    conn
    |> put_flash(:info, "Place deleted successfully.")
    |> redirect(to: place_path(conn, :index))
  end
end
