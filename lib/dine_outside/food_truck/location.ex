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

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:location_id, :applicant, :type, :description, :address, :status, :food_items, :latitude, :longitude, :approved])
    |> validate_required([:location_id, :applicant, :type, :description, :address, :status, :food_items, :latitude, :longitude, :approved])
  end
end
