defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    #Discuss.Topic
    #with alias just
    #Topic
    alias Discuss.Topic

    # when request comes nto this controller
    # this plug will execute only if that request is attempting
    # to go to one of these different functions
    # GUARD CLAUSE
    # plug gonna run in those
    plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    def index(conn, _params) do
        # query = from t in Topic, limit: 3
        # topics = Repo.all query
        topics = Repo.all(Topic)
        render conn, "index.html", topics: topics
    end

    def new(conn, _params) do
        #struct = %Topic{}
        #params = %{}
        changeset = Topic.changeset(%Topic{}, %{})

        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"topic" => topic}) do
        #%{"topic" => topic} = params
        # changeset = Topic.changeset(%Topic{}, topic)

        changeset = conn.assigns.user
            |> build_assoc(:topics)
            |> Topic.changeset(topic)

        case Repo.insert changeset do
            {:ok, topic} -> 
                conn
                |> put_flash(:info, "Topic \"" <> topic.title <> "\" Created")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset
                # becouse of redirecting after empty string error to `/topics` which is not good logic
                # conn
                # |> put_flash(:error, "Empty String Cannot Be Added To Database")
                # |> redirect(to: topic_path(conn, :new))
        end
    end

    def edit(conn, %{"id" => topic_id}) do
        IO.inspect topic_id
        topic = Repo.get(Topic, topic_id)
        IO.inspect topic
        changeset = Topic.changeset(topic)
        IO.inspect changeset

        render conn, "edit.html", changeset: changeset, topic: topic
    end

    def update(conn, %{"id" => topic_id, "topic" => topic}) do
        old_topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic)
        # changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)
        # changeset = Topic |> Repo.get(topic_id) |> Topic.changeset(topic)
    
        case Repo.update changeset do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "edit.html", changeset: changeset, topic: old_topic
        end
    end

    def delete(conn, %{"id" => topic_id}) do
        # params got info about topic - just ID !!!
        # IO.puts "PARAMS of DELETE function ::::::::::::::"
        # IO.inspect params
        # IO.puts "::::::::::::::::::::::::::::::::::::::::"
        # Topic |> Repo.get!(topic_id) |> Repo.delete!
        Repo.get!(Topic, topic_id) |> Repo.delete!

        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: topic_path(conn, :index))
    end
end