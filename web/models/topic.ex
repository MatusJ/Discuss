defmodule Discuss.Topic do
    use Discuss.Web, :model

    schema "topics" do
        # IO.puts("************* model topic schema topics IAMHERE ")
        field :title, :string
    end

    def changeset(struct, params \\ %{}) do
        # IO.puts("************* Topic.changeset(struct, params) IAMHERE ")
        # IO.puts("############# STRUCT: ")
        # IO.inspect(struct)
        # IO.puts("############# ENDSTRUCT")
        # IO.puts("############# PARAMS: ")
        # IO.inspect(params)
        # IO.puts("############# ENDPARAMS")
        struct
        |> cast(params, [:title])
        |> validate_required([:title]) 
        |> unique_constraint(:title)
    end
end