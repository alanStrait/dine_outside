defmodule DineOutside.Repo do
  use Ecto.Repo,
    otp_app: :dine_outside,
    adapter: Ecto.Adapters.Postgres
end
