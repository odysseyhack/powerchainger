defmodule EnergyTreeWeb.EnergyTreeLiveView.PreferencesTest do
  use EnergyTreeWeb.ConnCase
  alias EnergyTreeWeb.EnergyTreeLiveView.Preferences

  # Doctests can be found inline in the modules' documentation.
  doctest Preferences

  # For more rigorous testing, perform proptests:
  import ExUnitProperties

  property "Preferences minimum battery accepts numbers in the range 0..99" do
    check all level <- StreamData.integer(0..99) do
      pref = Preferences.new |> Preferences.set_minimum_battery(level)

      assert pref.minimum_battery == level
    end
  end

  property "Preferences minimum battery rejecs numbers outside the range 0..99" do
    check all level <- StreamData.integer(), level not in (0..99) do
      assert_raise(ArgumentError, fn ->
        Preferences.new |> Preferences.set_minimum_battery(level)
      end)
    end
  end
end
