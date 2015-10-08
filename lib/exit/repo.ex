defmodule Exit.Repo do
  defstruct path: nil

  def bare(path) do
    %Exit.Repo{path: path}
  end
end
