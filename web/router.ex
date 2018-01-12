defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    # IO.puts("************* router pipeline :browser IAMHERE: ")
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    # IO.puts("************* router pipeline :api IAMHERE: ")
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    # IO.puts("************* router scope IAMHERE: ")

    get "/", TopicController, :index
    #get "/topic", TopicController, :index
    get "/topics/new", TopicController, :new
    post "/topics", TopicController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
