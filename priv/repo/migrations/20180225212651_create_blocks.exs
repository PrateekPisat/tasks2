defmodule Tasks2.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:blocks, [:post_id])
  end
end
