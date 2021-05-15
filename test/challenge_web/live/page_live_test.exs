defmodule ChallengeWeb.PageLiveTest do
  use ChallengeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Challenge"
    assert render(page_live) =~ "Challenge"
  end
end
