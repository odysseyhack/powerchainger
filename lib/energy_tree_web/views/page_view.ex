defmodule EnergyTreeWeb.PageView do
  # use EnergyTreeWeb, :view
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    Test
    """
  end

  def mount(_session, socket) do
    if(connected?(socket), do: Process.send_after(self(), :tick, 1000))
    {:ok, assign(socket, val: 72, mode: :cooling, time: :calendar.local_time())}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, time: :calendar.local_time())}
  end
end
