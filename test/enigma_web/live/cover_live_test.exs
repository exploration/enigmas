defmodule EnigmaWeb.CoverLiveTest do
  use EnigmaWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "svg"
    assert render(page_live) =~ "svg"
  end
end
