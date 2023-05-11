defmodule DineOutside.Repo.Migrations.IncreaseFoodItemSize do
  use Ecto.Migration

  def change do
    alter table("locations") do
      modify :food_items, :text
    end
  end
end
