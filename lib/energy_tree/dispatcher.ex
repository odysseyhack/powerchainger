defmodule EnergyTree.Dispatcher do
  use ExActor.GenServer, export: __MODULE__

  defstart start_link(_) do
    reschedule()
    initial_state(%{load: 0.5})
  end

  defhandleinfo :update_load do
    reschedule()

    millisec = :erlang.system_time / 100_000_000
    load = (:math.cos(:math.pi*2*(0.001) * millisec) * :math.cos(:math.pi*2*(0.007) * millisec) + 1) / 2

    EnergyTreeWeb.Endpoint.broadcast!("energy", "load_change", %{load: load})
    new_state(%{load: load})
  end

  defp reschedule() do
    Process.send_after(self(), :update_load, 100)
  end
end
