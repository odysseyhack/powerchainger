defmodule EnergyTreeWeb.PageControllerTest do
  use EnergyTreeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "EnergyTree"
  end
end
