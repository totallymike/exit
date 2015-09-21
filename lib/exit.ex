defmodule Exit do
  def init do
    init(".")
  end

  def init(path) do
    setup_git_directories(path)
    File.cd!(Path.join([path, ".git"]), fn() ->
      File.open! "HEAD", [:write], fn(file) ->
        IO.write(file, "refs/heads/master")
      end

      File.open! "config", [:write], fn(file) ->
        IO.write file, """
[core]
\tcore.repositoryformatversion=0
\tcore.filemode=true
\tcore.bare=false
\tcore.logallrefupdates=true
"""
      end

      File.open! "description", [:write], fn(_file) -> end
      File.open! "info/exclude", [:write], fn(_file) ->
      end
    end)
  end

  def setup_git_directories(path) do
    [
      "hooks",
      "info",
      "objects/info",
      "objects/pack",
      "refs/heads",
      "refs/tags"
    ]
    |> Enum.each(fn(sub_dir) ->
      File.mkdir_p!(Path.join([path, ".git", sub_dir]))
    end)
  end
end
