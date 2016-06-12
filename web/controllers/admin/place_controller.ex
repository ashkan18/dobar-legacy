defmodule Dobar.Admin.PlaceController do
  use Dobar.Web, :controller

  alias Dobar.{Place, Category, PlaceImage}

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.AuthenticationController, :permission_denied } }
  plug Dobar.Plug.Auth
  plug :scrub_params, "place" when action in [:create, :update]
  plug :load_categories when action in [:new, :create, :edit, :update]
  
  def index(conn, _params) do
    places = Repo.all(Place)
    render(conn, "index.html", places: places)
  end

  def new(conn, _params) do
    changeset = Place.changeset(%Place{})
    conn
      |> assign(:changeset, changeset)
      |> render("new.html")
  end

  def create(conn, %{"place" => place_params}) do
    changeset = Place.changeset(%Place{}, prepare_params(place_params))
    
    case Repo.insert(changeset) do
      {:ok, place} ->
        conn
          |> upload_logo(place, place_params)
          |> put_flash(:info, "Place created successfully.")
          |> redirect(to: place_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)
    render(conn, "show.html", place: place)
  end

  def edit(conn, %{"id" => id}) do
    place = Repo.get!(Place, id)
    changeset = Place.changeset(place)
    render(conn, "edit.html", place: place, changeset: changeset)
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Repo.get!(Place, id)
    changeset = Place.changeset(place, prepare_params(place_params))

    case Repo.update(changeset) do
      {:ok, place} ->
        conn
        |> upload_logo(place, place_params)
        |> put_flash(:info, "Place updated successfully.")
        |> redirect(to: place_path(conn, :show, place))
      {:error, changeset} ->
        render(conn, "edit.html", place: place, changeset: changeset)
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

  defp prepare_params(place_params) do
    
    if place_params !== :empty && Map.has_key?(place_params, "lat_lon") do
      {lat_lon, place_params} = Dict.pop(place_params, "lat_lon")
      [lat, lon] = String.split(lat_lon, ",")
      place_params = Dict.merge(place_params, %{"lat" => lat, "lon" => lon})
    end
    # format categories to include name tag
    categories = Dict.get(place_params, "categories_list")
                  |> Enum.map(fn c -> %{name: c} end)
    Dict.merge(place_params, %{"categories" => categories})
  end
  
  defp upload_logo(conn, place, place_params) do
    if Map.has_key?(place_params, "logo_image") do
      user = Guardian.Plug.current_resource(conn)
      %{"logo_image" => logo_image } = place_params
      upload_token = Integer.to_string(:os.system_time(:seconds))
      case upload_photo(logo_image, %{place_id: place.id, user_id: user.id, upload_token: upload_token}) do
        {:ok, url} ->
          logo_update_changeset = Place.changeset(place, %{"logo" => url})
          Repo.update(logo_update_changeset)
        {:error} ->
          put_flash(conn, :info, "There was an error in uploading logo, Try again later.")
      end
    end
    conn
  end

  defp upload_photo(photo_file, place_image_user_changeset) do
    case PlaceImage.store({photo_file, place_image_user_changeset}) do
      {:ok, result} ->
        {:ok, PlaceImage.url({%{file_name: result}, place_image_user_changeset})}
      _ -> {:error}
    end
  end

  defp load_categories(conn, _) do
    categories = Category
                  |> Category.alphabetical
                  |> Repo.all
    assign(conn, :categories, categories) 
  end
end
