defmodule EnergyTree.User.Server do
  use ExActor.GenServer, export: __MODULE__

  alias EnergyTree.Persistence
  alias EnergyTree.User

  defstart start_link(user_id) do
    user = case Persistence.load_user(user_id) do
      {:ok, user} -> user
      :error -> User.Struct.new(user_id: user_id)
    end
    initial_state({user_id, user})
  end

  defcall inspect, state: state, do: reply(state)

  defcast set(new_user), state: {user_id, state} do
    Task.start(fn ->
      Persistence.persist_user(new_user)
    end)
    new_state({user_id, new_user})
  end

  defcast persist(), state: {user_id, user} do
    Task.start(fn ->
      Persistence.persist_user(user)
    end)
    noreply({user_id, user})
  end

  defcast stop, do: stop_server(:normal)
end
