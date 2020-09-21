defmodule Trello.Task.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :name, :string
    field :position, :integer
    belongs_to :user, Trello.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name, :position, :user_id])
    |> validate_required([:name, :user_id])
  end
end
