defmodule Dobar.Public.RegistrationController do
  use Dobar.Web, :controller

  alias Dobar.{Repo, User}

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
          |> put_flash(:info, "Welcome #{user.name}.")
          |> Guardian.Plug.sign_in(user) # verify your logged in resource
          |> redirect(to: "/")

      {:error, changeset} ->
        conn
          |> put_flash(:error, "There was an issue creating your account.")
          |> render("new.html",%{changeset: changeset})
    end
  end
end