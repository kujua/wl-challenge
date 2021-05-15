defmodule Challenge.Model.Block do
  @moduledoc """
  Definition of a block.
  """

  @type t() :: %__MODULE__{
          number: integer(),
          time: DateTime.t()
        }

  @enforce_keys [:number, :time]
  defstruct number: 0,
            time: nil
end
