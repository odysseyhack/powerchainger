defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  defstruct page: :dashboard, user: EnergyTree.User.Struct.new, show_menu?: false

  @pages [:dashboard, :profile, :settings, :sign_out]
  @charging_modes [:charging, :saving]

  @impl true
  def render(assigns) do
    EnergyTreeWeb.PageView.render("index.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    schedule()

    {user_id, user} = EnergyTree.User.Server.inspect

    socket = socket
    |> assign([
      show_menu?: false,
      page: :dashboard,
      user: user,
      time: NaiveDateTime.utc_now,
      title: user.name || "Powerchainger"
    ])

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
    socket
    |> assign(show_menu?: !socket.assigns.show_menu?)
  end

  defp change_page(socket, page) when page in @pages do
    socket
    |> assign(page: page)
  end

  defp toggle_charging_mode(socket, charging_mode) when charging_mode in @charging_modes do
    socket
    |> assign(charging_mode: charging_mode)
  end

  defp schedule() do
    Process.send_after(self(), :tick, 100)
  end
end
