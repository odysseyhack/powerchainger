defmodule EnergyTree.DispatcherTest do
  use ExUnit.Case
  import ExUnitProperties

  test "the Dispatcher is started as part of the supervision tree" do
    res = EnergyTree.Dispatcher.start_link(nil)
    assert match?({:error, {:already_started, _}}, res)
  end

  test "the Dispatcher broadcasts energy changes periodically" do
    EnergyTreeWeb.Endpoint.subscribe("energy")
    :timer.sleep(500)

    assert_receive(%Phoenix.Socket.Broadcast{topic: "energy", event: "load_change", payload: %{load: _}})
  end
end
