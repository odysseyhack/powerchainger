defmodule EnergyTreeWeb.EnergyTreeLiveView.State do
  defstruct [:navigation, :preferences, :users, :current_user_id, :token_history, :energy_usage]

  alias EnergyTreeWeb.EnergyTreeLiveView.{Navigation, Preferences}

  @users %{
    0 => %{name: "Alice"},
    1 => %{name: "Batman"},
  }

  def new do
    %__MODULE__{navigation: Navigation.new, preferences: Preferences.new, users: @users, current_user_id: nil}
  end

  def user_by_index(index) do
    @users[index]
  end
end
