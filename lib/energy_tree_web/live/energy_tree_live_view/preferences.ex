defmodule EnergyTreeWeb.EnergyTreeLiveView.Preferences do
  require Integer
  @moduledoc """
  The preferences struct is used to store user preferences
  that are meant to persist to disk.

  (and in the future to IPFS and/or IOTA)
  """
  defstruct [:charging_mode, :saving_until, :minimum_battery, :has_ev?]

  @charging_modes [:charging, :saving]

  @doc """
  Initializes the Preference struct with some logical defaults.
  """
  def new(user_id \\ 0) do
    if Integer.is_odd(user_id) do
      %__MODULE__{
        has_ev?: false
      }
    else
        %__MODULE__{charging_mode: :saving,
                    saving_until: ~T[20:00:00],
                    minimum_battery: 25,
                    has_ev?: true
        }
    end
  end

  @doc """
  Changes the charging mode of the user's EV.

  Raises unless a supported mode is used.

      iex> Preferences.new |> Preferences.set_charging_mode(:saving) |> Map.get(:charging_mode)
      :saving
      iex> Preferences.new |> Preferences.set_charging_mode(:charging) |> Map.get(:charging_mode)
      :charging
      iex> Preferences.new |> Preferences.set_charging_mode(:i_do_not_exist) |> Map.get(:charging_mode)
      ** (ArgumentError) unsupported `mode`

  """
  def set_charging_mode(struct, mode) when mode in @charging_modes do
    %__MODULE__{struct | charging_mode: mode}
  end
  def set_charging_mode(struct, _mode) do
    raise ArgumentError, "unsupported `mode`"
  end

  @doc """
  Persists the time until the user allows their EV to be used for carbitrage.
  """
  def set_saving_until(struct, time) do
    %__MODULE__{struct | saving_until: time}
  end

  @doc """
  Sets the minimum battery amount that the user wants to keep in their EV.
  (the car will only be used for carbitrage if above this level)

  Values outside of the range 0..100 will raise.

      iex> Preferences.new |> Preferences.set_minimum_battery(20) |> Map.get(:minimum_battery)
      20

      iex> Preferences.new |> Preferences.set_minimum_battery(80) |> Map.get(:minimum_battery)
      80

      iex> Preferences.new |> Preferences.set_minimum_battery(-1) |> Map.get(:minimum_battery)
      ** (ArgumentError) improper `minimum_battery` value

      iex> Preferences.new |> Preferences.set_minimum_battery(100) |> Map.get(:minimum_battery)
      ** (ArgumentError) improper `minimum_battery` value

  """
  def set_minimum_battery(struct, minimum_battery) when minimum_battery in 0..99 do
    %__MODULE__{struct | minimum_battery: minimum_battery}
  end
  def set_minimum_battery(struct, _minimum_battery) do
    raise ArgumentError, "improper `minimum_battery` value"
  end
end
