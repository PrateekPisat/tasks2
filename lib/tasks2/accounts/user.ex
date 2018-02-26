defmodule Tasks2.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasks2.Accounts.User
  alias Tasks2.Accounts.Manage


  schema "users" do
    field :email, :string
    field :name, :string
    has_one :manager_manages, Manage, foreign_key: :manager_id
    has_many :underlings_managed, Manage, foreign_key: :underling_id
    has_one :manager, through: [:manager_manages, :manager]
    has_many :underlings, through: [:underlings_managed, :underling]

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
