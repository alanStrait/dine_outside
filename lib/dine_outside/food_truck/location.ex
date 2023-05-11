defmodule DineOutside.FoodTruck.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :address, :string
    field :applicant, :string
    field :approved, :string
    field :description, :string
    field :food_items, :string
    field :latitude, :float
    field :location_id, :integer
    field :longitude, :float
    field :status, :string
    field :type, :string

    timestamps()
  end

  def new(%{
    loc_id: loc_id,
    applicant: applicant,
    type: type,
    description: description,
    address: address,
    status: status,
    food_items: food_items,
    lat: lat,
    lon: lon,
    approved: approved,
  }) do
    %__MODULE__{
      address: address,
      applicant: applicant,
      approved: approved,
      description: description,
      food_items: food_items,
      latitude: lat,
      location_id: loc_id,
      longitude: lon,
      status: status,
      type: type,
    }
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:location_id, :applicant, :type, :description, :address, :status, :food_items, :latitude, :longitude, :approved])
    |> validate_required([:location_id, :applicant, :type, :description, :address, :status, :food_items, :latitude, :longitude, :approved])
  end
end
