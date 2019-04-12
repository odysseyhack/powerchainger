defmodule EnergyTreeWeb.PageController do
  use EnergyTreeWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.live_render(conn, "index.html")
  end
end
