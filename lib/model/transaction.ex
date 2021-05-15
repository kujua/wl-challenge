defmodule Challenge.Model.Transaction do
  @moduledoc """
  Definition of a transaction.
  """

  @type t() :: %__MODULE__{
          client_id: String.t(),
          tx_hash: String.t(),
          time: DateTime.t(),
          block: integer()
        }

  @enforce_keys [:tx_hash, :time, :block]
  defstruct client_id: nil,
            tx_hash: nil,
            time: nil,
            block: 0
end
