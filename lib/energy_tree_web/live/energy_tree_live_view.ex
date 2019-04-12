defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h1> <%= assigns.title %></h1>
    Current time: <%= inspect assigns.time %>
    """
  end

  def mount(_session, socket) do
    schedule()
    {:ok, assign(socket, val: 72, mode: :cooling, time: :calendar.local_time(), title: "Powerchainger")}
  end

  def handle_info(:tick, socket) do
    schedule()
    {:noreply, assign(socket, time: :calendar.local_time())}
  end

  defp schedule() do
    Process.send_after(self(), :tick, 100)
  end
end
