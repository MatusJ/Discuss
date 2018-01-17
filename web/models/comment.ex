defmodule Discuss.Comment do
    use Discuss.Web, :model

    # whenever poison looks on this model
    # just look at content
    @derive {Poison.Encoder, only: [:content]}

    schema "comments" do
        field :content, :string
        belongs_to :user, Discuss.User
        belongs_to :topic, Discuss.Topic

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:content])
        |> validate_required([:content])
    end
end