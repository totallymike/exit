defmodule Exit.Integration.ObjectTest do
  use ExitIntegrationTest.Case
  test "it writes the blob to a file" do
    Exit.init
    {:ok, id} = Exit.Object.hash_w("test content")
    assert File.exists?(".git/objects/08/cf6101416f0ce0dda3c80e627f333854c4085c")
    {object_contents, 0} = System.cmd("git", ["cat-file", "-p", id])
    {object_type, 0} = System.cmd("git", ["cat-file", "-t", id])
    assert "test content" == object_contents
    assert "blob" == object_type |> String.strip
  end
end
