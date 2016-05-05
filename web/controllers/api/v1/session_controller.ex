require IEx

defmodule Dobar.Api.V1.SessionController do
  use Dobar.Web, :controller

  alias Dobar.{Repo, User}

  def login(conn, params) do
    case authenticate(params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
        json(conn, %{jwt: jwt, user: user})
      :error ->
        permission_denied(conn, params)
    end
  end

  def logout(conn, _params) do
    Guardian.Plug.logout(conn)
      |> json(%{success: true})
  end

  def permission_denied(conn, params) do
    conn
      |> put_status(403)
      |> json(%{error: "Permission denied."})
  end
  
  defp authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end