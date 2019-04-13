defmodule EnergyTreeWeb.EnergyTreeLiveView.Preferences do
  defstruct [:charging_mode, :user_name, :saving_until]

  @charging_modes [:charging, :saving]

  def new do
    %__MODULE__{charging_mode: :charging, user_name: "Batman", saving_until: ~T[20:00:00]}
  end

  def set_charging_mode(struct, mode) when mode in @charging_modes do
    %__MODULE__{struct | charging_mode: mode}
  end

  def set_saving_until(struct, time) do
    IO.inspect({struct, time})
    %__MODULE__{struct | saving_until: time}
  end
end
