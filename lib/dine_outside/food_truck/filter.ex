defmodule DineOutside.FoodTruck.Filter do
  alias DineOutside.FoodTruck.Utility
  import Ecto.Changeset

  defstruct ~w(anchor_lat anchor_lon distance)a

  def new(%{
    "anchor_lat" => anchor_lat,
    "anchor_lon" => anchor_lon,
    "distance" => distance,
  }) do
    anchor_lat = Utility.parse_float(anchor_lat)
    anchor_lon = Utility.parse_float(anchor_lon)
    distance = Utility.parse_integer(distance)
    %__MODULE__{
      anchor_lat: anchor_lat,
      anchor_lon: anchor_lon,
      distance: distance
    }
  end

  @types %{anchor_lat: :float, anchor_lon: :float, distance: :integer}
  @doc false
  def changeset(filter, attrs) do
    {filter, @types}
    |> cast(attrs, [:anchor_lat, :anchor_lon, :distance])
    |> validate_required([:anchor_lat, :anchor_lon, :distance])
    |> validate_number(:anchor_lat, greater_than: 37.15, less_than: 38.28)
    |> validate_number(:anchor_lon, greater_than: -122.98, less_than: -121.72)
    |> validate_number(:distance, greater_than: 0, less_than: 25_000)
  end
end
