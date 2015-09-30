defmodule Exit.Integration.TreeTest do
  use ExitIntegrationTest.Case

  test "it can generate trees" do
    Exit.init
    tree = %Exit.Tree{}
    {:ok, tree} = Exit.Tree.add_blob(tree, "file1.txt", "test content", "100644")
    assert Kernel.length(Map.keys tree.contents) == 1

    {:ok, tree} = Exit.Tree.add_blob(tree, "file2.txt", "more content", "100644")
    assert Kernel.length(Map.keys tree.contents) == 2
    #{:ok, id} = Exit.Tree.write(tree)
  end

  test "it reads a tree" do
    System.cmd("git", ["init"])
    :ok = File.write("test.txt", "test content")
    :ok = File.write("file2.txt", "more content")
    System.cmd("git", ["add", "test.txt", "file2.txt"])
    {output, _status} = System.cmd("git", ["commit", "-m", "Initial commit"])
    {:ok, tree} = Exit.Tree.read!("1acd3817ae284fcf8171301203309d18cb89b297")
    assert tree.id == "1acd3817ae284fcf8171301203309d18cb89b297"
    assert tree.contents |> Enum.map(fn(entry) ->
      entry.filename
    end) == ["file2.txt", "test.txt"]
  end
end
