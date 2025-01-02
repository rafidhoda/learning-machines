defmodule LearningMachinesWeb.CounterLiveTest do
  use LearningMachinesWeb.ConnCase

  import Phoenix.LiveViewTest
  import LearningMachines.CountersFixtures

  @create_attrs %{count: 42}
  @update_attrs %{count: 43}
  @invalid_attrs %{count: nil}

  defp create_counter(_) do
    counter = counter_fixture()
    %{counter: counter}
  end

  describe "Index" do
    setup [:create_counter]

    test "lists all counters", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/counters")

      assert html =~ "Listing Counters"
    end

    test "saves new counter", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/counters")

      assert index_live |> element("a", "New Counter") |> render_click() =~
               "New Counter"

      assert_patch(index_live, ~p"/counters/new")

      assert index_live
             |> form("#counter-form", counter: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#counter-form", counter: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/counters")

      html = render(index_live)
      assert html =~ "Counter created successfully"
    end

    test "updates counter in listing", %{conn: conn, counter: counter} do
      {:ok, index_live, _html} = live(conn, ~p"/counters")

      assert index_live |> element("#counters-#{counter.id} a", "Edit") |> render_click() =~
               "Edit Counter"

      assert_patch(index_live, ~p"/counters/#{counter}/edit")

      assert index_live
             |> form("#counter-form", counter: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#counter-form", counter: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/counters")

      html = render(index_live)
      assert html =~ "Counter updated successfully"
    end

    test "deletes counter in listing", %{conn: conn, counter: counter} do
      {:ok, index_live, _html} = live(conn, ~p"/counters")

      assert index_live |> element("#counters-#{counter.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#counters-#{counter.id}")
    end
  end

  describe "Show" do
    setup [:create_counter]

    test "displays counter", %{conn: conn, counter: counter} do
      {:ok, _show_live, html} = live(conn, ~p"/counters/#{counter}")

      assert html =~ "Show Counter"
    end

    test "updates counter within modal", %{conn: conn, counter: counter} do
      {:ok, show_live, _html} = live(conn, ~p"/counters/#{counter}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Counter"

      assert_patch(show_live, ~p"/counters/#{counter}/show/edit")

      assert show_live
             |> form("#counter-form", counter: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#counter-form", counter: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/counters/#{counter}")

      html = render(show_live)
      assert html =~ "Counter updated successfully"
    end
  end
end
