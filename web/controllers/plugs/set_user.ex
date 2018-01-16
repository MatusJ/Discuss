defmodule Discuss.Plugs.SetUser do
    import Plug.Conn
    import Phoenix.Controller

    alias Discuss.Repo
    alias Discuss.User

    def init(_params) do
        # anything done one time on start and then
        #  all the time passed as second argument to call function
        # good for example for big computations
        # passed as _params everytime call function is called
    end

    def call(conn, _params) do
        # called when request comed throughout our pipeline,
        # params coming from _params of init function
        # get_session coming from Phoenix.Controller
        user_id = get_session(conn, :user_id)
        # conn.session.user_id # it is not Functional Programming approach

        cond do
            user = user_id && Repo.get(User, user_id) ->
                # not conn.asssigns.user => user struct
                # assign coming from Plug.Conn
                assign(conn, :user, user)
            true ->
                assign(conn, :user, nil)
        end
    end
end