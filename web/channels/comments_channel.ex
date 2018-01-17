defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel 

    alias Discuss.{Topic, Comment}

    # called when first JS client is attempting to join channel
    # onec during application lifecycle
    # first time communication
    def join("comments:" <> topic_id, _params, socket) do
        # IO.puts "++++++++++"
        # IO.inspect name
        # IO.inspect topic_id
        # name something like comments:24
        # replace name with pattern matching
        # we want integer not string
        topic_id = String.to_integer(topic_id)
        # we cannot sand it as JSON
        topic = Topic
            |> Repo.get(topic_id)
            # load associations
            |> Repo.preload(:comments)

        # {:ok, %{topic: topic}, socket}
        # can assign data to socket
        # socket behave similar as conn previously
        # {:ok, %{}, socket}
        {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    end

    # follow up communication
    def handle_in(name, %{"content" => content}, socket) do
        # IO.puts "+++++++++"
        # IO.inspect name
        # IO.inspect message
        # message has content from JS

        topic = socket.assigns.topic

        changeset = topic
            |> build_assoc(:comments)
            |> Comment.changeset(%{content: content})

        case Repo.insert(changeset) do
            {:ok, comment} ->
                # paasing error -> when users gonna get data that he is not supposed to
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end