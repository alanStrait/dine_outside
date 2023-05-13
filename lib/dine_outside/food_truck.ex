defmodule DineOutside.FoodTruck do
  @moduledoc """
  The FoodTruck context.
  """

  import Ecto.Query, warn: false
  alias DineOutside.FoodTruck.{Filter, Utility}
  alias DineOutside.Repo

  alias DineOutside.FoodTruck.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Returns a list of locations filtered by distance in meters.

  ## Examples

      iex> list_filtered_locations(%{"anchor_lat" => 37.7895, "anchor_lon" => -122.4046, "distance" => 500})
      [%Locations{}, ...]

  """
  def list_filtered_locations(params) do
    with  anchor_lat = Utility.parse_float(params["anchor_lat"]),
          anchor_lon = Utility.parse_float(params["anchor_lon"]),
          distance = Utility.parse_integer(params["distance"]),
          anchor_coords = {anchor_lon, anchor_lat} do
            Enum.filter(list_locations(), &within_great_circle?(anchor_coords, &1, distance))
          end
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset` for tracking filter changes.

  ## Examples

      iex> change_filter(filter)
      %Ecto.Changeset{data: %Filter{}}

  """
  def change_filter(%Filter{} = filter, attrs \\ %{}) do
    Filter.changeset(filter, attrs)
  end

  @doc """
  Returns true if provided location is within a great circle from the
  provided anchor coordinates representing the users location. Otherwise
  it returns false.

  ## Examples

      iex> within_great_circle?({{-122.4046, 37.7895}}, location, 500)
      boolean()

  """
  def within_great_circle?({_longitude, _latitude} = anchor_coordinates, location, meters) do
    meters >= Haversine.distance(anchor_coordinates, {location.longitude, location.latitude})
  end

  def within_great_circle?(_, _, _), do: false
end
