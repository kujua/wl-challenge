defmodule Challenge.Api.Server do
  @moduledoc """
  This module provides an api function to be called from the user interface when a transaction is sent.

  It subscribes to a channel to send the transaction list to the live component TableLive.

  When the MockMiner creates a block a message s send to this module.
  """

  use GenServer
  use Timex
  alias Challenge.DataService.TransactionStore
  alias Challenge.Model
  alias ChallengeWeb.Endpoint
  require Logger

  @transactions "transactions:"

  @spec send_transaction(String.t(), String.t()) :: boolean()
  def send_transaction(txhash, clientid \\ "") do
    if txhash_valid?(txhash) do
      GenServer.cast(:apiserver, {:send_transaction, {txhash, clientid}})
      true
    else
      false
    end
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(state), do: GenServer.start_link(__MODULE__, state, name: :apiserver)

  @impl true
  def init(state) do
    Endpoint.subscribe(@transactions)
    {:ok, state}
  end

  @impl true
  def handle_cast({:block_created, block}, _state) do
    Logger.info("SERVER: Block #{block.number} created at #{block.time} received")
    list = TransactionStore.get_success_list(block.number)

    Enum.each(list, fn e ->
      Logger.info("SERVER: send success for #{e.tx_hash}")
    end)

    Endpoint.broadcast_from(
      self(),
      @transactions,
      "successful-transactions",
      %{
        transactionlist: list
      }
    )

    {:noreply, block}
  end

  @impl true
  def handle_cast({:send_transaction, {txhash, clientid}}, state) do
    TransactionStore.add_transaction(%Model.Transaction{
      client_id: clientid,
      tx_hash: txhash,
      time: Timex.local(),
      block: state.number
    })

    {:noreply, state}
  end

  defp txhash_valid?(txhash) do
    Regex.match?(~r/^0x([A-Fa-f0-9]{64})$/, txhash)
  end
end
