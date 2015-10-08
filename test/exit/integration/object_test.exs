defmodule Exit.Integration.ObjectTest do
  # use ExitIntegrationTest.Case
  use ExUnit.Case

  @tag skip: "Meh"
  test "it writes the blob to a file" do
    Exit.init
    {:ok, id} = Exit.ObjectDB.add("test content", "blob")
    object = Exit.ObjectDB.fetch("08cf6101416f0ce0dda3c80e627f333854c4085c")

    assert object.id == "08cf6101416f0ce0dda3c80e627f333854c4085c"
    assert object.contents == "test content"

    assert File.exists?(".git/objects/08/cf6101416f0ce0dda3c80e627f333854c4085c")
    {object_contents, 0} = System.cmd("git", ["cat-file", "-p", id])
    {object_type, 0} = System.cmd("git", ["cat-file", "-t", id])
    assert "test content" == object_contents
    assert "blob" == object_type |> String.strip
  end
end
