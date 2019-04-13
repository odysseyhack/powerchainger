defmodule EnergyTreeWeb.Helpers do
  use Phoenix.HTML

  def circle_chart(value, percentage, label, sublabel, classes, sublabel_classes) do
    ~E"""
    <svg viewBox="0 0 36 36" class="c-circular-chart <%= classes |> Enum.join(" ") %>">
    <path class="c-circular-chart__bg" d="M18 2.0845
    a 15.9155 15.9155 0 0 1 0 31.831
    a 15.9155 15.9155 0 0 1 0 -31.831" />
    <path class="c-circular-chart__fill" stroke-dasharray="<%= percentage %>, 100" d="M18 2.0845
    a 15.9155 15.9155 0 0 1 0 31.831
    a 15.9155 15.9155 0 0 1 0 -31.831" />
    <text x="18" y="18.35" class="c-circular-chart__percentage"><%= value %></text>
    <text x="18" y="24" class="c-circular-chart__label"><%= label %></text>
    <text x="18" y="27.3" class="c-circular-chart__sublabel <%= sublabel_classes |> Enum.join(" ") %>"><%= sublabel %></text>
    </svg>
    """
  end
end

