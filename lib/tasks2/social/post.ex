defmodule Tasks2.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasks2.Social.Post


  schema "posts" do
    field :body, :string
    field :completed, :boolean, default: false
    field :name, :string
    belongs_to :user, Tasks2.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:name, :body, :completed, :user_id])
    |> validate_required([:name, :body, :completed, :user_id])
  end
end
