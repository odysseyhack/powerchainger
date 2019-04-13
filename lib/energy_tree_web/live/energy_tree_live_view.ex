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
    defstruct [:charging_mode, :user_name]

    @charging_modes [:charging, :saving]

    def new do
      %__MODULE__{charging_mode: :charging, user_name: "Batman"}
    end

    def set_charging_mode(struct, mode) when mode in @charging_modes do
      %__MODULE__{struct | charging_mode: mode}
    end
  end

  defmodule State do
    defstruct [:navigation, :preferences, :users]

    @users %{
      0 => %{name: "Alice", preferences: Preferences.new},
      1 => %{name: "Batman", preferences: Preferences.new},
    }

    def new do
      %__MODULE__{navigation: Navigation.new, preferences: Preferences.new, users: @users}
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

    {user_id, user} = EnergyTree.User.Server.inspect

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
          update_field(socket, :preferences, &Preferences.set_charging_mode(&1, String.to_existing_atom(charging_mode)))
    end
    IO.inspect(socket.assigns)
    {:noreply, socket}
  end

  defp sign_in(socket, user_id) do
    user = State.user_by_index(user_id)
    socket
    |> assign([
      preferences: user.preferences,
      navigation: socket.assigns.navigation |> Navigation.navigate_to(:dashboard)
    ])
  end

  defp sign_out(socket) do
    socket
    |> assign([
      preferences: nil,
      navigation: Navigation.new()
    ])
  end

  defp update_field(socket, field, fun) do
    new_val =
      socket.assigns[field]
      |> fun.()
    assign(socket, [{field, new_val}])
  end

  defp schedule() do
    Process.send_after(self(), :tick, 1000)
  end
end
