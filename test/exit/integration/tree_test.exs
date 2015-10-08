defmodule Exit.Integration.TreeTest do
  # use ExitIntegrationTest.Case
  use ExUnit.Case

  @tag skip: "Don't worry about writing trees yet"
  test "it can generate trees" do
    Exit.init
    tree = %Exit.Tree{}
    {:ok, tree} = Exit.Tree.add_blob(tree, "file1.txt", "test content", "100644")
    assert Kernel.length(Map.keys tree.contents) == 1

    {:ok, tree} = Exit.Tree.add_blob(tree, "file2.txt", "more content", "100644")
    assert Kernel.length(Map.keys tree.contents) == 2
    #{:ok, id} = Exit.Tree.write(tree)
  end

  test "it blows up doing a lookup on non-trees" do
    repo = Exit.Repo.bare("test/fixtures/testrepo.git")
    assert_raise Exit.InvalidTree, fn ->
      Exit.Tree.lookup!(repo, "fa49b077972391ad58037050f2a75f74e3671e92")
    end
  end

  test "it reads a tree" do
    repo = Exit.Repo.bare("test/fixtures/testrepo.git")
    {:ok, tree} = Exit.Tree.lookup!(repo, "c4dc1555e4d4fa0e0c9c3fc46734c7c35b3ce90b")
    assert tree.id == "c4dc1555e4d4fa0e0c9c3fc46734c7c35b3ce90b"
    assert tree.contents |> Enum.map(fn(entry) ->
      entry.filename
    end) == ["README", "new.txt", "subdir"]
  end
end
