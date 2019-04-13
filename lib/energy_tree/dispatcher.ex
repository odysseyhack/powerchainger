defmodule EnergyTree.Dispatcher do
  use ExActor.GenServer, export: __MODULE__

  defstart start_link do
    Process.send_after(self(), :update_load, 1000)
    initial_state(%{load: 42})
  end

  defhandleinfo :update_load do
    Process.send_after(self(), :update_load, 1000)

    millisec = :os.system_time
    load = :math.sin(:math.pi*2*(0.0002) * millisec)
    IO.inspect(load)

    new_state(%{load: load})
  end
end
