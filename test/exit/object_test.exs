defmodule Exit.ObjectTest do
  use ExUnit.Case, async: true
  # test "header" do
  #   header = Exit.Object.header("test content")
  #   assert
  # end

  test "it hashes a file with SHA-2" do
    hash = Exit.Object.hash("test content")
    assert hash == "08cf6101416f0ce0dda3c80e627f333854c4085c"
  end
end
