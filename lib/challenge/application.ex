defmodule Challenge.Application do
  @moduledoc false

  use Application
  alias Challenge.{Api, DataService, Model}

  def start(_type, _args) do
    children = [
      ChallengeWeb.Telemetry,
      {Phoenix.PubSub, name: Challenge.PubSub},
      ChallengeWeb.Endpoint,
      DataService.TransactionStore,
      {Api.Server, %Model.Block{number: 0, time: nil}},
      {Challenge.MockMiner, %Model.Block{number: 0, time: nil}}
    ]

    opts = [strategy: :one_for_one, name: Challenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
