defmodule Dobar.AuthenticationController do
  use Dobar.Web, :controller

  alias Dobar.{Repo, User}

  plug :scrub_params, "user" when action in [:login]
  
  def login_page(conn, _params) do
    render conn, changeset: User.changeset(%User{})
  end

  def login(conn, %{"user" => login_params}) do
    case authenticate(login_params) do
      {:ok, user} ->
        conn
          |> Guardian.Plug.sign_in(user)
          |> redirect(to: "/")
      :error ->
        conn
          |> render("login.html", changeset: %User{email: login_params[:email], password: '' })
    end
  end

  def logout(conn, _params) do
    Guardian.Plug.logout(conn)
      |> redirect(to: "/")
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