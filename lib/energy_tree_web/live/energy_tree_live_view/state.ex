defmodule EnergyTreeWeb.EnergyTreeLiveView.State do
  defstruct [:navigation, :preferences, :users, :current_user_id, :token_history, :energy_usage, :traffic_light, :battery_level, token_count: 0]

  alias EnergyTreeWeb.EnergyTreeLiveView.{Navigation, Preferences}

  @users %{
    0 => %{name: "Alice"},
    1 => %{name: "Batman"},
  }

  def new do
    %__MODULE__{navigation: Navigation.new,
                preferences: Preferences.new,
                users: @users,
                current_user_id: nil,
                energy_usage: 0,
                token_history: [],
                traffic_light: :green,
                battery_level: 42,
                token_count: 0
    }
  end

  def user_by_index(index) do
    @users[index]
  end

  def sign_in(state, user_id, preferences) do
    %__MODULE__{ state |
                 navigation: state.navigation |> Navigation.navigate_to(:dashboard),
                 preferences: preferences,
                 current_user_id: user_id,
                 energy_usage: 42,
                 token_history: (1..10 |> Enum.reverse),
                 battery_level: 50,
    }
  end

  def sign_out(state) do
    %__MODULE__{state |
                navigation: Navigation.new(),
                preferences: nil,
                current_user_id: nil,
                energy_usage: 0,
                token_history: [],
                battery_level: 42,
                token_count: 0
    }
  end

  def simulate_update_battery_level(state = %{traffic_light: :green}) do
    %__MODULE__{state | battery_level: state.battery_level + 1 }
  end

  def simulate_update_battery_level(state = %{traffic_light: :red}) do
    %__MODULE__{state | battery_level: state.battery_level - 1, token_count: state.token_count + 1}
  end

  def simulate_update_battery_level(state = %{traffic_light: :orange}) do
    state
  end
end
