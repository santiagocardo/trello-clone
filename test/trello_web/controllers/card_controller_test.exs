defmodule TrelloWeb.CardControllerTest do
  use TrelloWeb.ConnCase

  alias Trello.Task

  import Trello.Fixtures, only: [create_user: 1, create_list: 1]

  @create_attrs %{details: "some details", title: "some title"}
  @update_attrs %{details: "some updated details", title: "some updated title"}
  @invalid_attrs %{details: nil, title: nil}

  def fixture(:card) do
    {:ok, user: user} = create_user(true)
    {:ok, list: list} = create_list(true)
    attrs = Map.merge(@create_attrs, %{user_id: user.id, list_id: list.id})

    {:ok, card} = Task.create_card(attrs)
    card
  end

  describe "index" do
    test "lists all cards", %{conn: conn} do
      conn = get(conn, Routes.card_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Cards"
    end
  end

  describe "new card" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.card_path(conn, :new))
      assert html_response(conn, 200) =~ "New Card"
    end
  end

  describe "create card" do
    setup [:create_user, :create_list]

    test "redirects to show when data is valid", %{conn: conn, user: user, list: list} do
      attrs = Map.merge(@create_attrs, %{user_id: user.id, list_id: list.id})

      conn = post(conn, Routes.card_path(conn, :create), card: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.card_path(conn, :show, id)

      conn = get(conn, Routes.card_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Card"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.card_path(conn, :create), card: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Card"
    end
  end

  describe "edit card" do
    setup [:create_card]

    test "renders form for editing chosen card", %{conn: conn, card: card} do
      conn = get(conn, Routes.card_path(conn, :edit, card))
      assert html_response(conn, 200) =~ "Edit Card"
    end
  end

  describe "update card" do
    setup [:create_card]

    test "redirects when data is valid", %{conn: conn, card: card} do
      conn = put(conn, Routes.card_path(conn, :update, card), card: @update_attrs)
      assert redirected_to(conn) == Routes.card_path(conn, :show, card)

      conn = get(conn, Routes.card_path(conn, :show, card))
      assert html_response(conn, 200) =~ "some updated details"
    end

    test "renders errors when data is invalid", %{conn: conn, card: card} do
      conn = put(conn, Routes.card_path(conn, :update, card), card: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Card"
    end
  end

  describe "delete card" do
    setup [:create_card]

    test "deletes chosen card", %{conn: conn, card: card} do
      conn = delete(conn, Routes.card_path(conn, :delete, card))
      assert redirected_to(conn) == Routes.card_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.card_path(conn, :show, card))
      end
    end
  end

  defp create_card(_) do
    card = fixture(:card)
    %{card: card}
  end
end
