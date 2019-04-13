defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  alias EnergyTreeWeb.EnergyTreeLiveView.{Navigation, Preferences, State}

  @impl true
  def render(assigns) do
    EnergyTreeWeb.PageView.render("index.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    schedule()

    if connected?(socket) do
      :dets.open_file(Preferences, type: :set)
    end

    socket = socket
    |> assign(State.new |> Map.from_struct)

    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule()
    {:noreply, assign(socket, time: NaiveDateTime.utc_now)}
  end

  @impl true
  def handle_event(event, value, socket) do
    socket =
      case {event, value, socket} do
        {"sign_in", user_id, socket} ->
          sign_in(socket, String.to_integer(user_id))
        {"sign_out", _, socket} ->
          sign_out(socket)
        {"toggle_menu", _, socket} ->
          update_field(socket, :navigation, &Navigation.toggle_menu(&1))
        {"change_page", page, socket} ->
          update_field(socket, :navigation, &Navigation.navigate_to(&1, String.to_existing_atom(page)))
        {"toggle_charging_mode", charging_mode, socket} ->
          update_preferences(socket, &Preferences.set_charging_mode(&1, String.to_existing_atom(charging_mode)))
        {"change_saving_until", %{"hours" => hours, "minutes" => minutes}, socket} ->
          time = parse_time(hours, minutes)
          update_preferences(socket, &Preferences.set_saving_until(&1, time))
    end
    IO.inspect(socket.assigns)
    {:noreply, socket}
  end

  defp sign_in(socket, user_id) do
    preferences = load_preferences(user_id)

    socket
    |> update_state(&State.sign_in(&1, user_id, preferences))
  end

  defp sign_out(socket) do
    socket
    |> update_state(&State.sign_out(&1))
  end

  defp update_field(socket, field, fun) do
    new_val =
      socket.assigns[field]
      |> fun.()
    assign(socket, [{field, new_val}])
  end

  defp update_preferences(socket, fun) do
    socket = update_field(socket, :preferences, fun)
    preferences = socket.assigns.preferences
    user_id = socket.assigns.current_user_id
    :dets.insert(Preferences, {user_id, preferences})

    socket
  end

  defp update_state(socket, fun) do
    new_state = struct(State, socket.assigns)
    |> fun.()
    |> Map.from_struct

    assign(socket, new_state)
  end

  defp load_preferences(user_id) do
    case :dets.lookup(Preferences, user_id) do
      [{^user_id, preferences}] -> preferences
      [] -> Preferences.new
    end
  end

  defp schedule() do
    Process.send_after(self(), :tick, 1000)
  end

  defp parse_time(hours, minutes) do
    hours =
      "0" <> hours
      |> String.to_integer
      |> min(23)
      |> max(0)

    minutes =
      "0" <> minutes
      |> String.to_integer
      |> min(59)
      |> max(0)

    Time.from_erl!({hours, minutes, 0})
  end
end
