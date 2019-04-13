defmodule EnergyTreeWeb.EnergyTreeLiveView.Navigation do
  @moduledoc """
  The navigation module is responsible for managing the user's location inside the application.
  This data is treated as ephemeral data.
  """
  defstruct [:page, :show_settings?]

  @doc """
  Initializes the Navigation struct.
  We start at the signed out page.
  """
  def new do
    %__MODULE__{page: :signed_out, show_settings?: false}
  end

  @pages [:dashboard, :tokens, :profile, :settings, :signed_out]

  @doc """
  Moving to a different page.

  Will raise on paths that do not exist.

      iex> Navigation.new() |> Navigation.navigate_to(:tokens)
      %Navigation{page: :tokens, show_settings?: false}

      iex> Navigation.new() |> Navigation.navigate_to(:unexistent)
      ** (FunctionClauseError) no function clause matching in EnergyTreeWeb.EnergyTreeLiveView.Navigation.navigate_to/2
  """
  def navigate_to(struct, page) when page in @pages do
    %__MODULE__{struct | page: page}
  end

  @doc """
  Toggles if the settings menu is visible.

      iex> Navigation.new
      %Navigation{page: :signed_out, show_settings?: false}

      iex> Navigation.new |> Navigation.toggle_menu
      %Navigation{page: :signed_out, show_settings?: true}

      iex> Navigation.new |> Navigation.toggle_menu |> Navigation.toggle_menu
      %Navigation{page: :signed_out, show_settings?: false}
  """
  def toggle_menu(struct) do
    %__MODULE__{struct | show_settings?: !struct.show_settings?}
  end
end
