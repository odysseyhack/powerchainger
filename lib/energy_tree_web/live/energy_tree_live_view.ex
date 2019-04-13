defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  defmodule Navigation do
    defstruct [:page, :show_settings?]
    def new do
      %__MODULE__{page: :signed_out, show_settings?: false}
    end

    @pages [:dashboard, :tokens, :profile, :settings, :signed_out]

    def navigate_to(struct, page) when page in @pages do
      %__MODULE__{struct | page: page}
    end

    def toggle_menu(struct) do
      %__MODULE__{struct | show_settings?: !struct.show_settings?}
    end
  end

  defmodule Preferences do
    defstruct [:charging_mode, :user_name, :saving_until]

    @charging_modes [:charging, :saving]

    def new do
      %__MODULE__{charging_mode: :charging, user_name: "Batman", saving_until: ~T[20:00:00]}
    end

    def set_charging_mode(struct, mode) when mode in @charging_modes do
      %__MODULE__{struct | charging_mode: mode}
    end

    def set_saving_until(struct, time) do
      IO.inspect({struct, time})
      %__MODULE__{struct | saving_until: time}
    end
  end

  defmodule State do
    defstruct [:navigation, :preferences, :users, :current_user_id]

    @users %{
      0 => %{name: "Alice"},
      1 => %{name: "Batman"},
    }

    def new do
      %__MODULE__{navigation: Navigation.new, preferences: Preferences.new, users: @users, current_user_id: nil}
    end

    def user_by_index(index) do
      @users[index]
    end
  end


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
    user = State.user_by_index(user_id)
    socket
    |> assign([
      preferences: load_preferences(user_id),
      navigation: socket.assigns.navigation |> Navigation.navigate_to(:dashboard),
      current_user_id: user_id

    ])
  end

  defp sign_out(socket) do
    socket
    |> assign([
      preferences: nil,
      navigation: Navigation.new(),
      current_user_id: nil
    ])
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
