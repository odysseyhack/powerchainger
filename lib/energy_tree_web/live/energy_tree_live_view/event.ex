defmodule EnergyTreeWeb.EnergyTreeLiveView.Event do
  @moduledoc """
  An event describes a nice thing that someone did to influcence the net;
  it is one of the core gamification concepts.

  There are three kinds of events:

  - `:delivery` for when delivering energy back to the grid (e.g. using your Electric Vehicle or other battery as buffer).
  - `:outside_peak` for when using energy outside of peak hours, thus reducing load on the grid.
  - `:surplus` for when adding renewable energy such as solar power back to the grid.
  """

  @kinds [:delivery, :outside_peak, :surplus]

  defstruct [:kind, amount: 0, time: nil]

  def new(kind, amount, datetime = %NaiveDatetime{} \\ NaiveDateTime.utc_now) when kind in @kinds and amount >= 0 do
    %__MODULE__{kind: kind, amount: amount, datetime: datetime}
  end
  def new(_, _, _) do
    raise ArgumentError
  end
end
