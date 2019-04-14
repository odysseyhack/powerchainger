defmodule EnergyTreeWeb.PageView do
  use EnergyTreeWeb, :view

  alias EnergyTreeWeb.EnergyTreeLiveView.Preferences

  def to_trytes(str) when is_binary(str) do
    {:ok, trytes} = IotaEx.Trytes.from_binary(str)
    trytes
  end

  def render_event(event) do
  end
end
