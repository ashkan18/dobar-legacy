defmodule Dobar.Api.V1.PlaceController do
  use Dobar.Web, :controller

  def index(conn, params) do
    response = %{
              id: 2,
              name: "name of a place"
            }
    json conn, response
  end
end