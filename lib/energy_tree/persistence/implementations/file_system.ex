defmodule EnergyTree.Persistence.Implementations.FileSystem do
  @behaviour EnergyTree.Persistence.Behaviour

  def persist_user(user_struct) do
    user_struct
    |> :erlang.term_to_binary
    |> (&File.write!(filepath(user_struct.user_id), &1)).()

    :ok
  end

  def load_user(user_id) do
    case File.read(filepath(user_id)) do
      {:ok, data} ->
        user_state = :erlang.binary_to_term(data)
        {:ok, user_state}
      _ ->
        :error
    end
  end

  def list_user_ids do
    Path.wildcard("./persistence/*")
    |> Enum.map(&extract_user_id_from_filepath/1)
  end

  defp extract_user_id_from_filepath(filepath) do
    "user_state-" <> user_id =
      filepath
      |> Path.basename(".bin")

    user_id
  end

  defp filepath(user_id) do
    Path.join("./persistence/", "user_state-#{user_id}.bin")
    |> Path.expand
  end
end
