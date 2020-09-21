defmodule TrelloWeb.ActivityControllerTest do
  use TrelloWeb.ConnCase

  alias Trello.Task

  import Trello.Fixtures, only: [create_user: 1, create_card: 1]

  @create_attrs %{action: "some action"}
  @update_attrs %{action: "some updated action"}
  @invalid_attrs %{action: nil}

  def fixture(:activity) do
    {:ok, user: user} = create_user(true)
    {:ok, card: card} = create_card(true)
    attrs = Map.merge(@create_attrs, %{user_id: user.id, card_id: card.id})

    {:ok, activity} = Task.create_activity(attrs)
    activity
  end

  describe "index" do
    test "lists all activities", %{conn: conn} do
      conn = get(conn, Routes.activity_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Activities"
    end
  end

  describe "new activity" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.activity_path(conn, :new))
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "create activity" do
    setup [:create_user, :create_card]

    test "redirects to show when data is valid", %{conn: conn, user: user, card: card} do
      attrs = Map.merge(@create_attrs, %{user_id: user.id, card_id: card.id})

      conn = post(conn, Routes.activity_path(conn, :create), activity: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.activity_path(conn, :show, id)

      conn = get(conn, Routes.activity_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Activity"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.activity_path(conn, :create), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Activity"
    end
  end

  describe "edit activity" do
    setup [:create_activity]

    test "renders form for editing chosen activity", %{conn: conn, activity: activity} do
      conn = get(conn, Routes.activity_path(conn, :edit, activity))
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "update activity" do
    setup [:create_activity]

    test "redirects when data is valid", %{conn: conn, activity: activity} do
      conn = put(conn, Routes.activity_path(conn, :update, activity), activity: @update_attrs)
      assert redirected_to(conn) == Routes.activity_path(conn, :show, activity)

      conn = get(conn, Routes.activity_path(conn, :show, activity))
      assert html_response(conn, 200) =~ "some updated action"
    end

    test "renders errors when data is invalid", %{conn: conn, activity: activity} do
      conn = put(conn, Routes.activity_path(conn, :update, activity), activity: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Activity"
    end
  end

  describe "delete activity" do
    setup [:create_activity]

    test "deletes chosen activity", %{conn: conn, activity: activity} do
      conn = delete(conn, Routes.activity_path(conn, :delete, activity))
      assert redirected_to(conn) == Routes.activity_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.activity_path(conn, :show, activity))
      end
    end
  end

  defp create_activity(_) do
    activity = fixture(:activity)
    %{activity: activity}
  end
end
