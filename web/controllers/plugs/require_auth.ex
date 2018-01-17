defmodule Discuss.Plugs.RequireAuth do
    import Plug.Conn
    import Phoenix.Controller

    alias Discuss.Router.Helpers
    
    def init(_params) do
        # initial setup
        # long-running or expensive operations
    end

    def call(conn, _params) do
        if conn.assigns[:user] do
            # if exists user, pass conn
            conn
        else
            # user is not assigned, not logged in
            # show error
            conn 
            #both functions from Phoenix.Controller
            |> put_flash(:error, "You must be logged in.")
            |> redirect(to: Helpers.topic_path(conn, :index))
            # tells everything is done
            # Controller handlers are the last to do
            # impoer Plug.Conn
            |> halt()
        end
    end
end