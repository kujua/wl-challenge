defmodule Challenge.ComponentTest do
  use ChallengeWeb.ConnCase
  alias Challenge.Model

  describe "pagelive" do
    test "flash message for valid input" do
      {:noreply, socket} =
        ChallengeWeb.PageLive.handle_event(
          "save_transaction",
          %{"txhash" => "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"},
          %Phoenix.LiveView.Socket{assigns: %{flash: %{}}}
        )

      assert socket.assigns.flash["info"] ==
               "Transaction submitted. Result will appear in the table below."
    end

    test "flash message for invalid input" do
      {:noreply, socket} =
        ChallengeWeb.PageLive.handle_event(
          "save_transaction",
          %{"txhash" => "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0456"},
          %Phoenix.LiveView.Socket{assigns: %{flash: %{}}}
        )

      assert socket.assigns.flash["error"] == "Transaction error"
    end
  end

  describe "tablelive" do
    test "successful transaction event empty list" do
      payload = %{transactionlist: []}

      {:noreply, socket} =
        Challenge.TableLive.handle_info(
          %{event: "successful-transactions", payload: payload},
          %Phoenix.LiveView.Socket{assigns: %{flash: %{}}}
        )

      assert socket.assigns.transactions == []
    end

    test "successful transaction event" do
      txlist = [
        %Model.Transaction{
          client_id: "",
          tx_hash: "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0",
          time: Timex.local(),
          block: 5
        }
      ]

      payload = %{transactionlist: txlist}

      {:noreply, socket} =
        Challenge.TableLive.handle_info(
          %{event: "successful-transactions", payload: payload},
          %Phoenix.LiveView.Socket{assigns: %{flash: %{}}}
        )

      assert socket.assigns.transactions == txlist
    end
  end
end
