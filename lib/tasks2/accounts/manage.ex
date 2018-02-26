defmodule Tasks2.Accounts.Manage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasks2.Accounts.Manage


  schema "manages" do
    belongs_to :manager, Tasks2.Accounts.User
    belongs_to :underling, Tasks2.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Manage{} = manage, attrs) do
    manage
    |> cast(attrs, [:manager_id, :underling_id])
    |> validate_required([:manager_id, :underling_id])
  end
end
