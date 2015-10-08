defmodule Exit.Integration.RepoTest do
  use ExUnit.Case

  alias Exit.Repo

  test "it has a last commit" do
    repo = Repo.bare("test/fixtures/testrepo.git")
    assert repo.path == "test/fixtures/testrepo.git"
  end
end
