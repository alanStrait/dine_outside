# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DineOutside.Repo.insert!(%DineOutside.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

## DineOutside FoodTruck data from CSV
alias DineOutside.{FoodTruck, Repo}
alias DineOutside.FoodTruck.Location
alias NimbleCSV.RFC4180

mobile_food_truck_path = Path.join(File.cwd!(), "priv/Mobile_Food_Facility_Permit.csv")

mobile_food_truck_path
|> File.stream!()
|> RFC4180.parse_stream()
|> Stream.map(fn [
                loc_id,
                applicant,
                type,
                _,
                description,
                address,
                _,
                _,
                _,
                _,
                status,
                food_items,
                _,
                _,
                lat,
                lon,
                _,
                _,
                _,
                approved | _rest
              ] ->
  {loc_id, _} = Integer.parse(loc_id)
  # Make lat-lon accuracy 1.1 meter by reducing to 5 decimal places
  lat = lat |> Float.parse() |> then(fn {f, _} -> Float.round(f, 5) end)
  lon = lon |> Float.parse() |> then(fn {f, _} -> Float.round(f, 5) end)
  %{
    loc_id: loc_id,
    applicant: applicant,
    type: type,
    description: description,
    address: address,
    status: status,
    food_items: food_items,
    lat: lat,
    lon: lon,
    approved: approved
  }
end)
|> Enum.map(&Location.new(&1))
|> Enum.each(&Repo.insert(&1))
