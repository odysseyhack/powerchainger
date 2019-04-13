defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  defstruct page: :dashboard, user: EnergyTree.User.Struct.new, show_menu?: false

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
    case {event, value, socket} do
      {"changed_name", %{"q" => new_name}, socket} ->
        {user_id, user} = EnergyTree.User.Server.inspect
        user = user
          |> Map.put(:name, new_name)

        EnergyTree.User.Server.set(user)
        socket = assign(socket, title: new_name, user: user)
        {:noreply, socket}
      {"toggle_menu", _, socket} ->
        IO.inspect("Toggled menu!")
        socket = assign(socket, show_menu?: !socket.assigns.show_menu?)
        {:noreply, socket}
    end
  end

  defp schedule() do
    Process.send_after(self(), :tick, 100)
  end
end
