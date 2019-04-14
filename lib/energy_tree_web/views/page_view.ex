defmodule EnergyTreeWeb.PageView do
  use EnergyTreeWeb, :view

  alias EnergyTreeWeb.EnergyTreeLiveView.{Preferences, Event}

  def to_trytes(str) when is_binary(str) do
    {:ok, trytes} = IotaEx.Trytes.from_binary(str)
    trytes
  end

  def render_event(event) do
    ~E"""

    <div class="c-transaction">
      <div class="c-transaction__icon">
        <%= event_icon(event) %>
      </div>
      <div class="u-flex-grow">
        <div class="c-transaction__timestamp">
        <%= event.datetime |> Timex.format!("{h24}:{m}") %>
        </div>
        <div class="c-transaction__body">
          <div class="c-transaction__description">
            <%= event_description(event) %>
          </div>
          <div class="c-transaction__reward">
          +<%= event.amount %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def event_icon(%Event{kind: :delivery}), do: lightning_icon()
  def event_icon(%Event{kind: :surplus}), do: sun_icon()
  def event_icon(%Event{kind: :outside_peak}), do: peak_shaving_icon()

  def event_description(%Event{kind: :delivery}), do: "You’ve delivered back to the grid"
  def event_description(%Event{kind: :surplus}), do: "Used surplus of renewable energy"
  def event_description(%Event{kind: :outside_peak}), do: "Used energy outside peak hours"
end
