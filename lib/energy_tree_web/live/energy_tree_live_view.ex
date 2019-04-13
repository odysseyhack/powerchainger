defmodule EnergyTreeWeb.EnergyTreeLiveView do
  use Phoenix.LiveView

  defstruct page: :dashboard, user: EnergyTree.User.Struct.new

  @impl true
  def render(assigns) do

    EnergyTreeWeb.PageView.render("index.html", assigns)

    # ~L"""
    # <button>Menu</button>
    # <div>Traffic Light</div>
    # <div> Battery Indicator </div>
    # <div> 30% </div>
    # <div> 40 tokens </div>
    # <div Charging Mode </div>

    # <h1> <%= @user.name %></h1>
    # Current time: <%= @time %>

    # <form phx-change="changed_name" >
    #   <input name="q" placeholder="name" value="<%= @title %>" />
    # </form>

    # <h2>
    # In Trytes: <%= trytes %>
    # </h2>
    # """
  end

  @impl true
  def mount(_session, socket) do
    schedule()

    {user_id, user} = EnergyTree.User.Server.inspect
    {:ok, assign(socket, user: user, time: NaiveDateTime.utc_now, title: user.name || "Powerchainger")}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule()
    {:noreply, assign(socket, time: NaiveDateTime.utc_now)}
  end

  @impl true
  def handle_event("changed_name", %{"q" => new_name}, socket) do
    {user_id, user} = EnergyTree.User.Server.inspect
    user = user
    |> Map.put(:name, new_name)

    EnergyTree.User.Server.set(user)
    {:noreply, assign(socket, title: new_name, user: user)}
  end

  defp schedule() do
    Process.send_after(self(), :tick, 100)
  end
end
