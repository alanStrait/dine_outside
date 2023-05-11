defmodule DineOutside.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :location_id, :integer
      add :applicant, :string
      add :type, :string
      add :description, :string
      add :address, :string
      add :status, :string
      add :food_items, :string
      add :latitude, :float
      add :longitude, :float
      add :approved, :string

      timestamps()
    end
  end
end
