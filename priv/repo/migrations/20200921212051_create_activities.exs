defmodule Trello.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :action, :string
      add :user_id, references(:users, on_delete: :nilify_all)
      add :from_id, references(:lists, on_delete: :nilify_all)
      add :to_id, references(:lists, on_delete: :nilify_all)
      add :card_id, references(:cards, on_delete: :delete_all)

      timestamps()
    end

    create index(:activities, [:user_id])
    create index(:activities, [:from_id])
    create index(:activities, [:to_id])
    create index(:activities, [:card_id])
  end
end
