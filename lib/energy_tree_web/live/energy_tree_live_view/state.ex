defmodule EnergyTreeWeb.EnergyTreeLiveView.State do
  @moduledoc """
  This module manages the state inside the application.

  By handling state changes in a normalized but 'stateless' fashion,
  we enable code that is easy to test and refactor.
  """

  defstruct [:navigation, :preferences, :users, :current_user_id, :token_history, :energy_usage, :traffic_light, :battery_level, :token_count]

  alias EnergyTreeWeb.EnergyTreeLiveView.{Navigation, Preferences}

  @users %{
    0 => %{name: "Fortunate Alice", ev: :renault},
    1 => %{name: "Poor Joe", ev: nil},
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

  @doc """
  Signing in a user.
  """
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

  @doc """
  WHen signing out a user, we reset the state to a simple default.

  Do note that we do not throw away all state (which a call to `new/0` would do).
  """
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

  @doc """
  Updates the battery level based on the current state of the local energy grid.

  This is a simulation, since the algorithm is simplified.
  The intent of this simplification is to make it more demo-friendly (by e.g. speeding up the notion of time).

  During 'green' times, we charge the battery:

      iex> State.new().battery_level
      42
      iex> State.new |> Map.put(:traffic_light, :green) |> State.simulate_update_battery_level() |> Map.get(:battery_level)
      43

  During 'red' times, the battery is discharged, but you receive a token as reward.

      iex> State.new |> Map.get(:battery_level)
      42
      iex> new_state = State.new |> Map.put(:traffic_light, :red) |> State.simulate_update_battery_level()
      iex> new_state.battery_level
      41
      iex> new_state.token_count
      1

  During 'orange' times, the battery is left alone.

      iex> State.new().battery_level
      42
      iex> State.new().token_count
      0
      iex> new_state = State.new |> Map.put(:traffic_light, :orange) |> State.simulate_update_battery_level()
      iex> new_state.battery_level
      42
      iex> new_state.token_count
      0

  """
  def simulate_update_battery_level(state = %{preferences: %{has_ev?: false}, traffic_light: :green}) do
    %__MODULE__{state | token_count: state.token_count + 1 }
  end

  def simulate_update_battery_level(state = %{preferences: %{charging_mode: :charging}}) do
    %__MODULE__{state | battery_level: min(state.battery_level + 1, 100) }
  end

  def simulate_update_battery_level(state = %{traffic_light: :green}) do
    %__MODULE__{state | battery_level: min(state.battery_level + 1, 100) }
  end

  def simulate_update_battery_level(state = %{traffic_light: :red}) do
    if state.preferences.minimum_battery < state.battery_level do
      %__MODULE__{state | battery_level: state.battery_level - 1, token_count: state.token_count + 1}
    else
      state
    end
  end

  def simulate_update_battery_level(state = %{traffic_light: :orange}) do
    state
  end

  def simulate_update_battery_level(_state = %{traffic_light: _other}) do
    raise ArgumentError
  end
end
