defmodule EnergyTreeWeb.EnergyTreeLiveView.Event do
  @moduledoc """
  An event describes a nice thing that someone did to influcence the net;
  it is one of the core gamification concepts.

  There are three kinds of events:

  - `:delivery` for when delivering energy back to the grid (e.g. using your Electric Vehicle or other battery as buffer).
  - `:outside_peak` for when using energy outside of peak hours, thus reducing load on the grid.
  - `:surplus` for when adding renewable energy such as solar power back to the grid.
  """
  use Timex

  @kinds [:delivery, :outside_peak, :surplus]

  defstruct [:kind, amount: 0, datetime: nil]

  def new(kind, amount, datetime \\ Timex.now)
  def new(kind, amount, datetime) when kind in @kinds and amount >= 0 do
    %__MODULE__{kind: kind, amount: amount, datetime: datetime}
  end
  def new(_, _, _) do
    raise ArgumentError
  end

  def fake_history do
    now = Timex.now()
    for hours_ago <- (0..100 |> Enum.reverse), Integer.mod(hours_ago, 3) != 0, Integer.mod(hours_ago, 5) != 0 do
      time = now |> Timex.shift(hours: -3 * hours_ago)
      pseudorandom_amount = Integer.mod(hours_ago * 65_533, 97)
      pseudorandom_kind = case Integer.mod(hours_ago * 17, 7) do
                            1 -> :outside_peak
                            2 -> :surplus
                            _ -> :delivery
                          end
      new(pseudorandom_kind, pseudorandom_amount, time)
    end
  end
end
