defmodule Dobar.Plug.Auth do
  import Plug.Conn
  def init(_opts) do
  end
  
  def call(conn, _repo) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, user)
  end
end