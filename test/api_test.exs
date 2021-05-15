defmodule Challenge.ApiTest do
  use ChallengeWeb.ConnCase
  use Timex
  alias Challenge.Api.Server
  alias Challenge.Model

  test "send_transaction/1" do
    assert Server.send_transaction(
             "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
           )
  end

  test "send_transaction/1 invalid input" do
    refute Server.send_transaction("1")
  end

  test "send_transaction/1 invalid hash" do
    refute Server.send_transaction(
             "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd033"
           )
  end

  test "block_created" do
    new_block = %Model.Block{number: 99, time: Timex.local()}
    GenServer.cast(:apiserver, {:block_created, new_block})
  end
end
