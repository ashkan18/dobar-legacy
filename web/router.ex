defmodule Dobar.Router do
  use Dobar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug Guardian.Plug.VerifySession # Looks in the Authorization session for the token
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader # Looks in the Authorization header for the token
    plug Guardian.Plug.LoadResource
  end

  scope "/", Dobar do
    pipe_through :browser # Use the default browser stack
    
    get "/", PageController, :index
    get "/login", AuthenticationController, :login_page
    post "/authentication", AuthenticationController, :login
    resources "/registrations", RegistrationController, only: [:new, :create]
    
    scope "admin/" do
      pipe_through :admin
      resources "/users", Admin.UserController
      resources "/places", Admin.PlaceController
      resources "/categories", Admin.CategoryController
    end
  end

  scope "/api", Dobar.Api, as: :api do
    pipe_through :api
    scope "/v1", V1, as: :v1 do
      resources "/images",  ImageController
      resources "/users",   Dobar.Api.UserController
      resources "/places",  Dobar.Api.PlaceController
      resources "/user_place_reviews", UserPlaceReviewController, only: [:create]
      post "/sessions", SessionController, :login
      delete "/sessions", SessionController, :logout
    end
  end

end
