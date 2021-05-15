defmodule Challenge.DataService.TransactionStore do
  @moduledoc """
  This is anm in-memory store to keep transactions.

  Data is not saved to a persistent store, so it gets lost when the application closes.
  """

  use Agent
  alias Challenge.Model
  require Logger

  @spec get_success_list(integer) :: list(Model.Transaction.t())
  def get_success_list(threshold) do
    list =
      Agent.get(__MODULE__, fn state ->
        Enum.filter(state, fn o ->
          o.block + 2 < threshold
        end)
      end)

    list
  end

  @spec add_transaction(Model.Transaction.t()) :: :ok
  def add_transaction(transaction) do
    Logger.info("STORE: transaction added: #{transaction.tx_hash}")
    Agent.update(__MODULE__, fn state -> List.insert_at(state, 0, transaction) end)
  end

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(initial_value \\ []) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end
end
