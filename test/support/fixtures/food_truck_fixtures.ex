defmodule DineOutside.FoodTruckFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DineOutside.FoodTruck` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        address: "some address",
        applicant: "some applicant",
        approved: "some approved",
        description: "some description",
        food_items: "some food_items",
        latitude: 120.5,
        location_id: 42,
        longitude: 120.5,
        status: "some status",
        type: "some type"
      })
      |> DineOutside.FoodTruck.create_location()

    location
  end
end
