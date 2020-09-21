defmodule Trello.Task.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string

    belongs_to :card, Trello.Task.Card
    belongs_to :user, Trello.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :card_id, :user_id])
    |> validate_required([:body, :card_id, :user_id])
  end
end
