defmodule Dobar.RegistrationController  do
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
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        json(conn, %{jwt: jwt, user: user})

      {:error, changeset} ->
        json(conn,%{changeset: changeset})
    end
  end
end