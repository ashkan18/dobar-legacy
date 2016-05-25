require IEx
defmodule Dobar.Public.PlaceImageUserController do
  use Dobar.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.AuthenticationController, :permission_denied } }
  plug Dobar.Plug.Auth

  alias Dobar.{PlaceImageUser, Repo, PlaceImage, Place}

  plug :scrub_params, "place_image_user" when action in [:create, :update]
  
  def new(conn, params) do
    changeset = PlaceImageUser.changeset(%PlaceImageUser{})
    render(conn, "new.html", changeset: changeset, place_id: params["place_id"])
  end

  def create(conn, %{"place_image_user" => place_image_user_params}) do
    user = Guardian.Plug.current_resource(conn)
    
    %{"photo" => photo_file, "place_id" => place_id} = place_image_user_params

    url = upload_photo(photo_file, %{place_id: place_id, user_id: user.id})
    changeset = PlaceImageUser.changeset(%PlaceImageUser{}, %{place_id: place_id, user_id: user.id, url: url})
    case Repo.insert(changeset) do
      {:ok, _place_image_user} ->
        conn
        |> put_flash(:info, "Image uploaded successfully.")
        |> redirect(to: place_path(conn, :show, %Place{id: place_id}))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, place_id: place_id)
    end
  end

  defp upload_photo(photo_file, place_image_user_changeset) do
    case PlaceImage.store({photo_file, place_image_user_changeset}) do
      {:ok, result} ->
        PlaceImage.url({%{file_name: result}, place_image_user_changeset})
      _ -> nil
    end
  end
end