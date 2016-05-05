defmodule Dobar.Api.V1.UserController do
  use Dobar.Web, :controller

  alias Dobar.User

  plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { Dobar.Api.V1.SessionController, :permission_denied } }

  def index(conn, params) do
    conn
      |> json(%{users: Repo.all(User)})
  end
end