defmodule Trello.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string
      add :details, :text
      add :list_id, references(:lists, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:cards, [:list_id])
    create index(:cards, [:user_id])
    create unique_index(:cards, [:title, :list_id])
  end
end
