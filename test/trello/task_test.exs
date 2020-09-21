defmodule Trello.TaskTest do
  use Trello.DataCase

  alias Trello.Task

  import Trello.Fixtures,
    only: [
      get_or_create_user: 0,
      card_fixture: 0,
      list_fixture: 0,
      list_fixture: 1,
      user_fixture: 1
    ]

  @create_list_attrs %{name: "some list name"}
  @create_user_attrs %{username: "some username"}

  describe "lists" do
    alias Trello.Task.List

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Task.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Task.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      user = user_fixture(@create_user_attrs)
      attrs = Map.put(@valid_attrs, :user_id, user.id)

      assert {:ok, %List{} = list} = Task.create_list(attrs)
      assert list.name == "some name"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Task.update_list(list, @update_attrs)
      assert list.name == "some updated name"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_list(list, @invalid_attrs)
      assert list == Task.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Task.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Task.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Task.change_list(list)
    end
  end

  describe "cards" do
    alias Trello.Task.Card

    @valid_attrs %{details: "some details", title: "some title"}
    @update_attrs %{details: "some updated details", title: "some updated title"}
    @invalid_attrs %{details: nil, title: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Task.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Task.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      user = user_fixture(@create_user_attrs)
      list = list_fixture(@create_list_attrs)

      attrs = Map.merge(@valid_attrs, %{user_id: user.id, list_id: list.id})

      assert {:ok, %Card{} = card} = Task.create_card(attrs)
      assert card.details == "some details"
      assert card.title == "some title"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, %Card{} = card} = Task.update_card(card, @update_attrs)
      assert card.details == "some updated details"
      assert card.title == "some updated title"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_card(card, @invalid_attrs)
      assert card == Task.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Task.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Task.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Task.change_card(card)
    end
  end

  describe "comments" do
    alias Trello.Task.Comment

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def comment_fixture(attrs \\ %{}) do
      user = get_or_create_user()
      card = card_fixture()

      {:ok, comment} =
        attrs
        |> Map.merge(%{user_id: user.id, card_id: card.id})
        |> Enum.into(@valid_attrs)
        |> Task.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Task.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Task.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      user = get_or_create_user()
      card = card_fixture()
      attrs = Map.merge(@valid_attrs, %{user_id: user.id, card_id: card.id})

      assert {:ok, %Comment{} = comment} = Task.create_comment(attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Task.update_comment(comment, @update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_comment(comment, @invalid_attrs)
      assert comment == Task.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Task.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Task.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Task.change_comment(comment)
    end
  end

  describe "activities" do
    alias Trello.Task.Activity

    @valid_attrs %{action: "some action"}
    @update_attrs %{action: "some updated action"}
    @invalid_attrs %{action: nil}

    def activity_fixture(attrs \\ %{}) do
      user = get_or_create_user()
      card = card_fixture()

      {:ok, activity} =
        attrs
        |> Map.merge(%{user_id: user.id, card_id: card.id})
        |> Enum.into(@valid_attrs)
        |> Task.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Task.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Task.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      user = get_or_create_user()
      card = card_fixture()
      attrs = Map.merge(@valid_attrs, %{user_id: user.id, card_id: card.id})

      assert {:ok, %Activity{} = activity} = Task.create_activity(attrs)
      assert activity.action == "some action"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Task.update_activity(activity, @update_attrs)
      assert activity.action == "some updated action"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_activity(activity, @invalid_attrs)
      assert activity == Task.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Task.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Task.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Task.change_activity(activity)
    end
  end
end
