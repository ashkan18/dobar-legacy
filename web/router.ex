defmodule Dobar.Router do
  use Dobar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader # Looks in the Authorization header for the token
    plug Guardian.Plug.LoadResource
  end

  scope "/", Dobar do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/places", PlaceController
    resources "/registrations", RegistrationController, only: [:new, :create]
  end

  scope "/api", Dobar.Api, as: :api do
    pipe_through :api
    scope "/v1", V1, as: :v1 do
      resources "/images",  ImageController
      resources "/reviews", ReviewController
      resources "/users",   UserController
      resources "/places",  PlaceController
      post "/sessions", SessionController, :login
    end
  end

end
