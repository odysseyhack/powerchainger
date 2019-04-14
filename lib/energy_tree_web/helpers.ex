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

  def charging_color_class(mode)
  def charging_color_class(:charging), do: "c-circular-chart__sublabel--orange"
  def charging_color_class(:discharging), do: "c-circular-chart__sublabel--green"
  def charging_color_class(:idle), do: "c-circular-chart__sublabel--grey"
  def charging_color_class(:charged), do: "c-circular-chart__sublabel--green"


  def pig_icon do
    ~E"""
    <div class="c-transaction__icon">
    <svg width="20" height="19" xmlns="http://www.w3.org/2000/svg"><g fill="#C3C9CB" fill-rule="evenodd"><path d="M1.487 12.669c-.331-1.132-.459-2.3-.256-3.418.37-2.042 1.79-3.544 4.39-4.206 1.843-.455 3.687-.38 5.38.02.398.093.717.187.947.266l4.929-.704.026.838c.01.355-.063.776-.2 1.268-.057.207-.125.422-.202.642-.06.172-.121.342-.185.505.172.182.36.4.55.65.379.5.669 1.016.834 1.544l1.924.715-.985 3.315h-1.723l-.087.111c-.25.318-.522.636-.812.934-.4.413-.798.756-1.107.947.086 1.27.116 1.783.116 1.89v.75h-3.001l-.733-1.201-.199.023c-.931.101-1.898.13-2.814.04-.783-.076-1.479-.235-2.12-.53l-.156 1.668H2.717l-.912-5.161a8.104 8.104 0 0 1-.318-.906zm10.29-5.798l-.185-.073a7.36 7.36 0 0 0-.934-.274c-1.48-.348-3.092-.414-4.672-.024-2.03.517-3.014 1.558-3.279 3.02-.155.854-.052 1.8.22 2.728.108.373.215.65.28.79l.059.185.709 4.013h.662l.192-2.059h.683c.29 0 .688.148 1.124.463.448.24 1.059.394 1.79.466.798.078 1.667.052 2.505-.04.29-.031.503-.062.615-.082l.503-.088.818 1.34h.615c-.022-.351-.054-.839-.1-1.491l-.033-.497.252-.085.192-.14c.34-.17.735-.492 1.147-.917a10.605 10.605 0 0 0 .983-1.18l.223-.322h1.374l.266-.898-1.382-.513-.075-.423c-.072-.41-.308-.87-.66-1.335a6.223 6.223 0 0 0-.73-.804l-.416-.361.221-.505a12.57 12.57 0 0 0 .502-1.39l-3.469.496z" fill-rule="nonzero"/><path d="M11.366 3.153c0 1.607-1.332 2.902-2.965 2.902-1.632 0-2.964-1.295-2.964-2.902C5.437 1.545 6.769.25 8.4.25c1.633 0 2.965 1.295 2.965 2.903zm-1.5 0c0-.77-.65-1.403-1.465-1.403-.813 0-1.464.633-1.464 1.403s.65 1.402 1.464 1.402 1.465-.633 1.465-1.402z" fill-rule="nonzero"/><path d="M1.436 9.76a.708.708 0 0 1-.718.699A.709.709 0 0 1 0 9.76c0-.386.321-.698.718-.698.397 0 .718.312.718.698M14.066 10.284a.709.709 0 0 1-.718.698.708.708 0 0 1-.718-.698c0-.385.321-.698.718-.698.397 0 .718.313.718.698"/></g></svg>
    </div>

    """
  end

  def lightning_icon do
    ~E"""
    <svg width="11" height="23" xmlns="http://www.w3.org/2000/svg"><path d="M3.44 21.31c-.065-.05 1.167-8.198 1.127-8.279-.04-.081-3.28-1.478-3.397-1.694-.08-.162 6.325-10.195 6.39-10.147.093.045-1.17 8.183-1.133 8.236.037.053 3.304 1.446 3.397 1.694.097.276-6.259 10.259-6.384 10.19z" stroke="#C3C9CB" stroke-width="1.5" fill="none" fill-rule="evenodd"/></svg>
    """
  end

  def peak_shaving_icon do
    ~E"""
    <div class="c-transaction__icon">
    <svg width="20" height="11" xmlns="http://www.w3.org/2000/svg"><g fill="#C3C9CB" fill-rule="nonzero"><path d="M19.907 9.25c-1.568-.05-2.434-1.038-4.054-4.1l-.03-.057a46.297 46.297 0 0 0-.638-1.179C13.79 1.442 12.49.25 10.447.25c-2.045 0-3.358 1.2-4.749 3.664-.183.325-.333.603-.638 1.179l-.03.057C3.41 8.212 2.544 9.2.976 9.25l.048 1.5c2.337-.075 3.455-1.351 5.332-4.898l.03-.057c.299-.565.444-.834.619-1.144 1.15-2.038 2.094-2.901 3.442-2.901 1.344 0 2.277.856 3.432 2.901.174.31.32.58.618 1.144l.03.057c1.877 3.547 2.995 4.823 5.332 4.898l.048-1.5z"/><path d="M1 4.5h1v-1H1v1zm2 0h1v-1H3v1zm2 0h1v-1H5v1zm2 0h1v-1H7v1zm2 0h1v-1H9v1zm2 0h1v-1h-1v1zm2 0h1v-1h-1v1zm2 0h1v-1h-1v1zm2 0h1v-1h-1v1zm2 0h1v-1h-1v1z"/></g></svg>
    </div>
    """
  end

  def sun_icon do
    ~E"""
    <div class="c-transaction__icon">
    <svg width="19" height="19" xmlns="http://www.w3.org/2000/svg"><path d="M5.257 9.594c0-.616.119-1.197.357-1.743s.56-1.022.966-1.428a4.593 4.593 0 0 1 1.427-.965A4.314 4.314 0 0 1 9.75 5.1c.616 0 1.197.119 1.743.357.546.237 1.021.56 1.427.965.406.406.728.882.966 1.428.238.546.357 1.127.357 1.743 0 .616-.119 1.197-.357 1.742a4.593 4.593 0 0 1-.966 1.428 4.593 4.593 0 0 1-1.427.966 4.314 4.314 0 0 1-1.743.357 4.314 4.314 0 0 1-1.743-.357 4.593 4.593 0 0 1-1.427-.966 4.593 4.593 0 0 1-.966-1.428 4.314 4.314 0 0 1-.357-1.742zM9.75 6.906a2.59 2.59 0 0 0-1.9.788 2.59 2.59 0 0 0-.787 1.9c0 .742.262 1.375.787 1.9a2.59 2.59 0 0 0 1.9.787 2.59 2.59 0 0 0 1.9-.787 2.59 2.59 0 0 0 .787-1.9 2.59 2.59 0 0 0-.787-1.9 2.59 2.59 0 0 0-1.9-.788zm-.903 8.966h1.806v2.687H8.847v-2.687zm0-15.244h1.806v2.688H8.847V.628zM.785 8.691h2.687v1.806H.785V8.69zm15.243 0h2.687v1.806h-2.687V8.69zM2.779 15.305l1.89-1.911 1.28 1.26-1.91 1.91-1.26-1.26zM13.55 4.534l1.89-1.911 1.28 1.26-1.91 1.91-1.26-1.26zm-8.86 1.26L2.78 3.882l1.26-1.26 1.91 1.91-1.26 1.26zm12.03 9.51l-1.28 1.26-1.89-1.91 1.26-1.26 1.91 1.91z" fill="#C3C9CB" fill-rule="nonzero"/></svg>
    </div>
    """
  end
end

