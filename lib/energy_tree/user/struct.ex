defmodule EnergyTree.User.Struct do
  defstruct name: "", ev: %{}

  def new(map \\ %{}) do
    struct(__MODULE__, map)
  end
end
