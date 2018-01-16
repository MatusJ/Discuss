defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User

    # in assign developers stash data used in whole app
    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        # IO.puts "+++++++++++++++++"
        # IO.inspect conn
        # IO.puts "+++++++++++++++++"
        # IO.inspect params
        # IO.puts "+++++++++++++++++"
        # %{params: %{"provider" => provider}} = conn
        # IO.inspect provider
        # IO.puts "+++++++++++++++++"
        # %{"provider" => prov} = params
        # IO.inspect prov
        # IO.puts "+++++++++++++++++"
        
        # user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
        # %{params: %{"provider" => provider}} = conn
        user_params = %{
            token: auth.credentials.token, 
            email: auth.info.email, 
            provider: to_string(auth.provider)
        }
        changest = User.changeset(%User{}, user_params)

        signin(conn, changest)
    end

    # public handler
    def signout(conn, _params) do
        #sign them out and redirect somewhere
        conn
        |> put_flash(:info, "Signed out!")
        # |> configure_session(drop: true)
        |> clear_session
        |> redirect(to: topic_path(conn, :index))
        # |> put_flash(:info, "Signed out!")
        # |> put_session(:user_id, nil)
        # |> redirect(to: topic_path(conn, :index))
    end

    # private function, cannot be called from other modules
    defp signin(conn, changeset) do
        case insert_or_update_user(changeset) do
            {:ok, user} ->
                # IO.puts "+++++++"
                # IO.inspect user
                # IO.puts "+++++++"
                conn
                |> put_flash(:info, "Welcome back!")
                |> put_session(:user_id, user.id)
                |> redirect(to: topic_path(conn, :index))
            {:error, _reason} ->
                conn
                |> put_flash(:error, "Error signin in")
                |> redirect(to: topic_path(conn, :index))
        end
    end

    defp insert_or_update_user(changeset) do
        # IO.puts "+++++++++++"
        # IO.inspect changeset
        # IO.puts "+++++++++++"
        # add user just once in database
        # firstly check whether we have one with that email
        # can be problem when email is set to be not public
        case Repo.get_by(User, email: changeset.changes.email) do
            nil ->
                # not neccesary will be succesful
                # any insert databse connection problem
                Repo.insert(changeset)
            user -> 
                {:ok, user}
        end
    end
end