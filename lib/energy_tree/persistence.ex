defmodule EnergyTree.Persistence do
  def persist_user(user_struct) do
    persistence_impl().persist_user(user_struct)
  end

  def load_user(user_key) do
    persistence_impl().load_user(user_key)
  end

  def list_user_ids do
    persistence_impl().list_user_ids()
  end

  def persistence_impl do
    Application.get_env(EnergyTree, :game_persistence_implementation, EnergyTree.Persistence.Implementations.FileSystem)
  end
end
