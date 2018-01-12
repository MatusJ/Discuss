defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    #Discuss.Topic
    #with alias just
    #Topic
    alias Discuss.Topic

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

    def create(conn, %{"topic" => topic} = params) do
        #%{"topic" => topic} = params
        changeset = Topic.changeset(%Topic{}, topic)

        case Repo.insert(changeset) do
            {:ok, post} -> 
                IO.puts("############# POST: ")
                IO.inspect(post)
                IO.puts("############# ENDPOST")
                conn
                |> put_flash(:info, "Topic \"" <> post.title <> "\" Created")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset
                # conn
                # |> put_flash(:info, "Empty String Cannot Be Added To Database")
                # |> redirect(to: topic_path(conn, :index))
        end
    end

    def edit(conn, %{"id" => topic_id}) do
        
    end
end