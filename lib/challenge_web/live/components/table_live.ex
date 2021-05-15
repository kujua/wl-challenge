defmodule Challenge.TableLive do
  @moduledoc """
  This component defines a live view table that is updated when data changes.

  This module subscribes to a channel to get the transaction list from the Server.
  """

  use ChallengeWeb, :live_view
  use Timex
  alias ChallengeWeb.Endpoint

  @transactions "transactions:"

  @impl true
  @dialyzer {:nowarn_function, mount: 3}
  def mount(_params, _session, socket) do
    Endpoint.subscribe(@transactions)

    {:ok,
     assign(
       socket,
       transactions: []
     )}
  end

  @impl true
  def handle_info(%{event: "successful-transactions", payload: payload}, socket) do
    {:noreply,
     assign(socket,
       transactions: payload.transactionlist
     )}
  end

  @spec format_time(DateTime.t()) :: String.t()
  def format_time(datetime) do
    {:ok, formatted_time} = Timex.format(datetime, "{D}.{M}.{YYYY} {h24}:{m}.{s}")
    formatted_time
  end
end
