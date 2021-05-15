defmodule ChallengeWeb.PageLive do
  @moduledoc """
  This is the live main page for the application.

  An event is raised via phx-submit when the submit button in the UI is pressed.
  """

  use ChallengeWeb, :live_view
  alias Challenge.Api.Server

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, txhashinput: "", results: %{})}
  end

  @impl true
  def handle_event("save_transaction", %{"txhash" => txhashinput}, socket) do
    Process.send_after(self(), :clear_flash, 3000)

    if process(txhashinput) do
      {:noreply,
       socket
       |> put_flash(:info, "Transaction submitted. Result will appear in the table below.")
       |> assign(results: %{}, txhashinput: txhashinput)}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Transaction error")
       |> assign(results: %{}, txhashinput: txhashinput)}
    end
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  defp process(txhashinput) do
    Server.send_transaction(txhashinput)
  end
end
