defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  defmodule Navigation do
    defstruct [:page, :show_menu?]
    def new do
      %__MODULE__{page: :dashboard, show_menu?: false}
    end

    @pages [:dashboard, :profile, :settings, :sign_out]

    def navigate_to(struct, page) when page in @pages do
      %__MODULE__{struct | page: page}
    end

    def toggle_menu(struct) do
      %__MODULE__{struct | show_menu?: !struct.show_menu?}
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

  # defstruct page: :dashboard, user: EnergyTree.User.Struct.new, show_menu?: false
  defmodule State do
    defstruct [:navigation, :preferences]

    def new do
      %__MODULE__{navigation: Navigation.new, preferences: Preferences.new}
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
        {"changed_name", %{"q" => new_name}, socket} ->
          change_name(socket, new_name)
        {"toggle_menu", _, socket} ->
          toggle_menu(socket)
        {"change_page", page, socket} ->
          change_page(socket, String.to_existing_atom(page))
        {"toggle_charging_mode", charging_mode, socket} ->
          toggle_charging_mode(socket, String.to_existing_atom(charging_mode))
    end
    IO.inspect(socket.assigns)
    {:noreply, socket}
  end

  defp change_name(socket, new_name) do
    {user_id, user} = EnergyTree.User.Server.inspect
    user =
      user
      |> Map.put(:name, new_name)

    EnergyTree.User.Server.set(user)
    assign(socket, title: new_name, user: user)
  end

  defp toggle_menu(socket) do
    navigation =
      socket.assigns.navigation
      |> Navigation.toggle_menu()
    socket
    |> assign(navigation: navigation)
  end

  defp change_page(socket, page) do
    navigation =
      socket.assigns.navigation
      |> Navigation.navigate_to(page)
    socket
    |> assign(navigation: navigation)
  end

  defp toggle_charging_mode(socket, charging_mode) do
    preferences =
      socket.assigns.preferences
      |> Preferences.set_charging_mode(charging_mode)

    socket
    |> assign(preferences: preferences)
  end

  defp schedule() do
    Process.send_after(self(), :tick, 1000)
  end
end
