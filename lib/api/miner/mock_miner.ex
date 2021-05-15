defmodule Challenge.MockMiner do
  @moduledoc """
  This module implements a mock block miner.
  The interval between block creation is random between 3 and @schedule_time seconds.
  """

  use GenServer
  use Timex
  alias Challenge.Model
  require Logger

  @schedule_time 7_000

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)

  @impl true
  def init(state) do
    schedule()
    {:ok, state}
  end

  @impl true
  def handle_info(:create_block, state) do
    current_date = Timex.local()
    new_block = %Model.Block{number: state.number + 1, time: current_date}
    Logger.info("Block #{new_block.number} created at #{current_date}")
    GenServer.cast(:apiserver, {:block_created, new_block})
    schedule()
    {:noreply, new_block}
  end

  @spec schedule :: nil | reference
  def schedule do
    schedule_time = Enum.random(3_000..@schedule_time)
    Process.send_after(self(), :create_block, schedule_time)
  end
end
