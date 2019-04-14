defmodule EnergyTree.Persistence.Behaviour do
  @callback persist_user(EnergyTree.User.t) :: :ok | :error

  @callback load_user(user_id :: any) :: {:ok, EnergyTree.User.t} | :error

  @callback list_user_ids :: [any]
end
