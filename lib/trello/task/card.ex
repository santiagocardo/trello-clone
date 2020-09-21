defmodule Trello.Task.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :details, :string
    field :title, :string

    belongs_to :list, Trello.Task.List
    belongs_to :user, Trello.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :details, :list_id, :user_id])
    |> validate_required([:title, :details, :list_id, :user_id])
  end
end
