defmodule Exit.TreeEntry do
  defstruct id: nil, mode: nil, filename: nil
  @type t :: %__MODULE__{id: binary, mode: binary, filename: binary}
end
