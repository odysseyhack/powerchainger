defmodule EnergyTree.User.Struct do
  defstruct name: "", ev: %{}, user_id: nil

  def new(map \\ %{}) do
    struct(__MODULE__, map)
  end

  defmodule Dashboard do
    defstruct []
  end
end
