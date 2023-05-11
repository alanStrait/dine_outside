defmodule DineOutside.FoodTruckTest do
  use DineOutside.DataCase

  alias DineOutside.FoodTruck

  describe "locations" do
    alias DineOutside.FoodTruck.Location

    import DineOutside.FoodTruckFixtures

    @invalid_attrs %{address: nil, applicant: nil, approved: nil, description: nil, food_items: nil, latitude: nil, location_id: nil, longitude: nil, status: nil, type: nil}

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert FoodTruck.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert FoodTruck.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{address: "some address", applicant: "some applicant", approved: "some approved", description: "some description", food_items: "some food_items", latitude: 120.5, location_id: 42, longitude: 120.5, status: "some status", type: "some type"}

      assert {:ok, %Location{} = location} = FoodTruck.create_location(valid_attrs)
      assert location.address == "some address"
      assert location.applicant == "some applicant"
      assert location.approved == "some approved"
      assert location.description == "some description"
      assert location.food_items == "some food_items"
      assert location.latitude == 120.5
      assert location.location_id == 42
      assert location.longitude == 120.5
      assert location.status == "some status"
      assert location.type == "some type"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FoodTruck.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      update_attrs = %{address: "some updated address", applicant: "some updated applicant", approved: "some updated approved", description: "some updated description", food_items: "some updated food_items", latitude: 456.7, location_id: 43, longitude: 456.7, status: "some updated status", type: "some updated type"}

      assert {:ok, %Location{} = location} = FoodTruck.update_location(location, update_attrs)
      assert location.address == "some updated address"
      assert location.applicant == "some updated applicant"
      assert location.approved == "some updated approved"
      assert location.description == "some updated description"
      assert location.food_items == "some updated food_items"
      assert location.latitude == 456.7
      assert location.location_id == 43
      assert location.longitude == 456.7
      assert location.status == "some updated status"
      assert location.type == "some updated type"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = FoodTruck.update_location(location, @invalid_attrs)
      assert location == FoodTruck.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = FoodTruck.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> FoodTruck.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = FoodTruck.change_location(location)
    end
  end
end
