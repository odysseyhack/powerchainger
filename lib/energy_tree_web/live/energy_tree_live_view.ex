defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h1> <%= @title %></h1>
    Current time: <%= @time %>

    <form phx-change="changed_name" >
      <input name="q" placeholder="name" value="<%= @title %>" />
    </form>
    """
  end

  def mount(_session, socket) do
    schedule()
    {:ok, assign(socket, val: 72, mode: :cooling, time: NaiveDateTime.utc_now, title: "Powerchainger")}
  end

  def handle_info(:tick, socket) do
    schedule()
    {:noreply, assign(socket, time: NaiveDateTime.utc_now)}
  end

  def handle_event("changed_name", %{"q" => new_name}, socket) do
    {:noreply, assign(socket, title: new_name)}
  end

  defp schedule() do
    Process.send_after(self(), :tick, 100)
  end
end
