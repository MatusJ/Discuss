defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel 

    alias Discuss.Topic

    # called when first JS client is attempting to join channel
    # onec during application lifecycle
    # first time communication
    def join("comments:" <> topic_id, _params, socket) do
        # IO.puts "++++++++++"
        # IO.inspect name
        # name something like comments:24
        # replace name with pattern matching
        # we want integer not string
        topic_id = String.to_integer(topic_id)
        # we cannot sand it as JSON
        topic = Repo.get(Topic, topic_id)

        # {:ok, %{topic: topic}, socket}
        {:ok, %{}, socket}
    end

    # follow up communication
    def handle_in(name, %{"content" => content}, socket) do
        # IO.puts "+++++++++"
        # IO.inspect name
        # IO.inspect message
        # message has content from JS


        # paasing error when users gonna get data that he is not supposed to
        {:reply, :ok, socket}
    end
end