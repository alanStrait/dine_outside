defmodule DineOutsideWeb.LocationLiveTest do
  use DineOutsideWeb.ConnCase

  import Phoenix.LiveViewTest
  import DineOutside.FoodTruckFixtures

  @create_attrs %{address: "some address", applicant: "some applicant", approved: "some approved", description: "some description", food_items: "some food_items", latitude: 120.5, location_id: 42, longitude: 120.5, status: "some status", type: "some type"}
  @update_attrs %{address: "some updated address", applicant: "some updated applicant", approved: "some updated approved", description: "some updated description", food_items: "some updated food_items", latitude: 456.7, location_id: 43, longitude: 456.7, status: "some updated status", type: "some updated type"}
  @invalid_attrs %{address: nil, applicant: nil, approved: nil, description: nil, food_items: nil, latitude: nil, location_id: nil, longitude: nil, status: nil, type: nil}

  defp create_location(_) do
    location = location_fixture()
    %{location: location}
  end

  describe "Index" do
    setup [:create_location]

    test "lists all locations", %{conn: conn, location: location} do
      {:ok, _index_live, html} = live(conn, ~p"/locations")

      assert html =~ "Listing Locations"
      assert html =~ location.address
    end

    test "saves new location", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/locations")

      assert index_live |> element("a", "New Location") |> render_click() =~
               "New Location"

      assert_patch(index_live, ~p"/locations/new")

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#location-form", location: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/locations")

      html = render(index_live)
      assert html =~ "Location created successfully"
      assert html =~ "some address"
    end

    test "updates location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, ~p"/locations")

      assert index_live |> element("#locations-#{location.id} a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(index_live, ~p"/locations/#{location}/edit")

      assert index_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#location-form", location: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/locations")

      html = render(index_live)
      assert html =~ "Location updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes location in listing", %{conn: conn, location: location} do
      {:ok, index_live, _html} = live(conn, ~p"/locations")

      assert index_live |> element("#locations-#{location.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#locations-#{location.id}")
    end
  end

  describe "Show" do
    setup [:create_location]

    test "displays location", %{conn: conn, location: location} do
      {:ok, _show_live, html} = live(conn, ~p"/locations/#{location}")

      assert html =~ "Show Location"
      assert html =~ location.address
    end

    test "updates location within modal", %{conn: conn, location: location} do
      {:ok, show_live, _html} = live(conn, ~p"/locations/#{location}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Location"

      assert_patch(show_live, ~p"/locations/#{location}/show/edit")

      assert show_live
             |> form("#location-form", location: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#location-form", location: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/locations/#{location}")

      html = render(show_live)
      assert html =~ "Location updated successfully"
      assert html =~ "some updated address"
    end
  end
end
