defmodule Trello.Fixtures do
  alias Trello.Accounts
  alias Trello.Task

  @create_user_attrs %{username: "some username"}
  @create_list_attrs %{name: "some list name", position: 0}
  @create_card_attrs %{details: "some card details", title: "some card title"}

  def card_fixture(attrs \\ %{}) do
    user = get_or_create_user()
    list = list_fixture()

    {:ok, card} =
      attrs
      |> Map.merge(%{user_id: user.id, list_id: list.id})
      |> Enum.into(@create_card_attrs)
      |> Task.create_card()

    card
  end

  def list_fixture(attrs \\ %{}) do
    user = get_or_create_user()

    {:ok, list} =
      attrs
      |> Map.put(:user_id, user.id)
      |> Enum.into(@create_list_attrs)
      |> Task.create_list()

    list
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@create_user_attrs)
      |> Accounts.create_user()

    user
  end

  def create_user(_) do
    user = user_fixture(@create_user_attrs)
    {:ok, user: user}
  end

  def create_list(_) do
    list = list_fixture(@create_list_attrs)
    {:ok, list: list}
  end

  def create_card(_) do
    card = card_fixture(@create_card_attrs)
    {:ok, card: card}
  end

  def get_or_create_user() do
    case Elixir.List.last(Trello.Accounts.list_users()) do
      nil ->
        user_fixture(@create_user_attrs)

      existing_user ->
        existing_user
    end
  end
end
