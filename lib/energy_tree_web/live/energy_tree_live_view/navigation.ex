defmodule EnergyTreeWeb.EnergyTreeLiveView.Navigation do
  defstruct [:page, :show_settings?]
  def new do
    %__MODULE__{page: :signed_out, show_settings?: false}
  end

  @pages [:dashboard, :tokens, :profile, :settings, :signed_out]

  @doc """
  Moving to a different page.

  Will raise on paths that do not exist.

  iex> Navigation.new() |> navigate_to(:tokens)
  %Navigation{page: :tokens, show_settings?: false}

  iex> Navigation.new() |> navigate_to(:unexistent)
  *** ArgumentError
  """
  def navigate_to(struct, page) when page in @pages do
    %__MODULE__{struct | page: page}
  end

  def toggle_menu(struct) do
    %__MODULE__{struct | show_settings?: !struct.show_settings?}
  end
end
