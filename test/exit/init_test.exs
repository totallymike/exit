defmodule Exit.InitTest do
  use ExUnit.Case

  alias File

  setup_all do
    current_dir = File.cwd!
    File.cd! System.tmp_dir

    on_exit fn ->
      File.cd! System.tmp_dir
      File.rm_rf "git_test"
      File.rm_rf "exit_test"
      File.cd! current_dir
    end
  end

  test "it creates the .git dir" do
    File.cd(System.tmp_dir)

    File.mkdir("git_test")
    File.cd! "git_test"
    System.cmd("git", ["init"])

    git_contents = ls_r(".git")

    File.cd! ".."

    File.mkdir!("exit_test")
    File.cd!("exit_test")
    Exit.init(".")

    exit_contents = ls_r(".git")

    File.cd ".."

    assert exit_contents == git_contents
  end

  def ls_r(path) do
    File.ls!(path)
    |> Enum.map(fn(item) ->
      full_path = Path.join(path, item)
      case File.dir?(full_path) do
        true -> [full_path, ls_r(full_path)]
        false -> [full_path]
      end
    end)
    |> List.flatten
    |> Enum.filter(fn(path) ->
      !String.match?(path, ~r/sample|branches/)
    end)
    |> Enum.sort
  end
end
