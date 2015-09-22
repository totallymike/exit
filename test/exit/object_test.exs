defmodule Exit.ObjectTest do
  use ExUnit.Case

  setup context do
    dir = Map.get(context, :test_dir, "git_test")
    File.cd! System.tmp_dir
    File.mkdir! dir
    File.cd! dir
    on_exit fn ->
      File.cd! System.tmp_dir
      File.rm_rf "git_test"
    end
    :ok
  end

  # test "header" do
  #   header = Exit.Object.header("test content")
  #   assert
  # end

  test "it hashes a file with SHA-2" do
    hash = Exit.Object.hash("test content")
    assert hash == "08cf6101416f0ce0dda3c80e627f333854c4085c"
  end

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
