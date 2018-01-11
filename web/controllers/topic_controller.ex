defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    #Discuss.Topic
    #with alias just
    #Topic
    alias Discuss.Topic

    def new(conn, _params) do
        #struct = %Topic{}
        #params = %{}
        changeset = Topic.changeset(%Topic{}, %{})

        render conn, "new.html"
    end
end