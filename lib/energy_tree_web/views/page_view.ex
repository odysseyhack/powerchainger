defmodule EnergyTreeWeb.PageView do
  use EnergyTreeWeb, :view
  def to_trytes(str) when is_binary(str) do
    {:ok, trytes} = IotaEx.Trytes.from_binary(str)
    trytes
  end
end
