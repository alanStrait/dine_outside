defmodule DineOutsideWeb.LocationLive.Index do
  use DineOutsideWeb, :live_view

  alias DineOutside.FoodTruck.Filter
  alias DineOutside.FoodTruck
  alias DineOutside.FoodTruck.Location

  @impl true
  def mount(_params, _session, socket) do
    filter = Filter.new(%{"anchor_lat" => 37.7895, "anchor_lon" => -122.4046, "distance" => 5_000})
    filter_changeset = Filter.changeset(filter, %{})
    locations = FoodTruck.list_locations()

    socket =
      socket
      |> assign(:filter, filter)
      |> assign(:locations, locations)
      |> assign(:filtered_locations, locations)
      |> assign(form: to_form(filter_changeset, as: :filter))

    {:ok, stream(socket, :locations, FoodTruck.list_locations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Location")
    |> assign(:location, FoodTruck.get_location!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Location")
    |> assign(:location, %Location{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Locations")
    |> assign(:location, nil)
  end

  @impl true
  def handle_info({DineOutsideWeb.LocationLive.FormComponent, {:saved, location}}, socket) do
    {:noreply, stream_insert(socket, :locations, location)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    location = FoodTruck.get_location!(id)
    {:ok, _} = FoodTruck.delete_location(location)

    {:noreply, stream_delete(socket, :locations, location)}
  end

  @impl true
  def handle_event("filter", %{"filter" => filter_params}, socket) do
    current_locations = socket.assigns.filtered_locations

    filtered_locations = FoodTruck.list_filtered_locations(filter_params)

    to_delete = current_locations -- filtered_locations
    socket = delete_from_streams_locations(socket, to_delete)

    to_add = filtered_locations -- current_locations
    socket = add_to_streams_locations(socket, to_add)

    socket =
      socket
      |> assign(:filtered_locations, filtered_locations)
      |> assign(form: to_form(filter_params, as: :filter))

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"filter" => filter_params}, socket) do
    changeset =
      socket.assigns.filter
      |> FoodTruck.change_filter(filter_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, as: :filter))
  end

  defp add_to_streams_locations(socket, []) do
    socket
  end
  defp add_to_streams_locations(socket, [element|[]]) do
    stream_insert(socket, :locations, element)
  end
  defp add_to_streams_locations(socket, [element|rest]) do
    socket = stream_insert(socket, :locations, element)
    add_to_streams_locations(socket, rest)
  end

  defp delete_from_streams_locations(socket, []), do: socket
  defp delete_from_streams_locations(socket, [element|[]]) do
    stream_delete(socket, :locations, element)
  end
  defp delete_from_streams_locations(socket, [element|rest]) do
    socket = stream_delete(socket, :locations, element)
    delete_from_streams_locations(socket, rest)
  end
end
