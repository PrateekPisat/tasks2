defmodule Tasks2.Time.Block do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasks2.Time.Block


  schema "blocks" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :post, Tasks2.Social.Post

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    block
    |> cast(attrs, [:start, :end, :post_id])
    |> validate_required([:post_id])
  end
end
