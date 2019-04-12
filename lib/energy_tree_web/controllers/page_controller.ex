defmodule EnergyTreeWeb.PageController do
  use EnergyTreeWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.Controller.live_render(conn, EnergyTreeWeb.EnergyTreeLiveView, session: %{})
  end
end
