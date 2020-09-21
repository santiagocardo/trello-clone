defmodule Trello.Task.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :action, :string

    belongs_to :user, Trello.Accounts.User
    belongs_to :card, Trello.Task.Card

    field :from_id, :id
    field :to_id, :id

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:action, :card_id, :from_id, :to_id, :user_id])
    |> validate_required([:action, :card_id, :user_id])
  end
end
