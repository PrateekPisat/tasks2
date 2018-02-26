defmodule Tasks2Web.Router do
  use Tasks2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
  end

  scope "/", Tasks2Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/posts", PostController
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    resources "/manages", ManageController

  end

  # Other scopes may use custom stacks.
  scope "/api/v1", Tasks2Web do
   pipe_through :api
   resources "/blocks", BlockController

  end
end
