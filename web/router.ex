defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    # function plugs
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # module plug
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    # get "/", TopicController, :index
    # get "/topics", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "topics/:id/edit", TopicController, :edit
    # put "topics/:id", TopicController, :update
    # delete .. seems we follow REST-ful standards

    # using resources, becouse we followed REST-ful standards 
    resources "/topics", TopicController
    get "/", TopicController, :index
  end

  scope "/auth", Discuss do
    pipe_through :browser

    get "/signout", AuthController, :signout # delete session, beaks REST-ful convention
    get "/:provider", AuthController, :request #handled by ueberauth
    get "/:provider/callback", AuthController, :callback #fixed by us
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
