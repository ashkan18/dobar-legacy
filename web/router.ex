defmodule Dobar.Router do
  use Dobar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authentication do
    plug Guardian.Plug.VerifySession # Looks in the Authorization session for the token
    plug Guardian.Plug.LoadResource
    plug Dobar.Plug.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader # Looks in the Authorization header for the token
    plug Guardian.Plug.LoadResource
  end

  scope "/", Dobar do
    pipe_through [:browser, :authentication] # Use the default browser stack
    
    get "/", Public.PlaceController, :index
    get "/login", AuthenticationController, :login_page
    get "/logout", AuthenticationController, :logout
    post "/authentication", AuthenticationController, :login
    resources "/register", Public.RegistrationController, only: [:new, :create]

    resources "/places", Public.PlaceController, only: [:show, :index]
    resources "/user_place_reviews", Public.UserPlaceReviewController, only: [:new, :create]
    resources "/place_image_users", Public.PlaceImageUserController, only: [:new, :create]
    
    scope "admin/" do
      resources "/users", Admin.UserController
      resources "/places", Admin.PlaceController
      resources "/categories", Admin.CategoryController
      resources "/cities", Admin.CityController
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
