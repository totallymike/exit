defmodule Exit.Tree do
  defstruct id: nil, size: nil, contents: %{}
  @type t :: %__MODULE__{id: binary, size: integer, contents: %{binary => Exit.TreeEntry.t}}

  @spec add_blob(Exit.Tree.t, binary, binary, binary) :: {:ok, Exit.Tree.t}
  def add_blob(tree, filename, content, mode) do
    {:ok, id} = Exit.ObjectDB.add_blob(content)
    entry = %Exit.TreeEntry{id: id, mode: mode, filename: filename}
    {:ok, insert_entry(tree, entry)}
  end

  def insert_entry(tree, entry) do
    tree = %Exit.Tree{tree | contents: Map.put(tree.contents, entry.filename, entry)}
  end

  @spec read!(binary) :: {atom, Exit.Tree.t}
  def read!(id) do
    tree = %Exit.Tree{id: id}
    {folder, filename} = String.split_at(id, 2)
    filename = Path.join([".git", "objects", folder, filename])
    contents = File.read!(filename) |> :zlib.uncompress
    [type_and_size, tree_contents] = String.split(contents, <<0>>, parts: 2)

    size = String.split(type_and_size) |> List.last |> Integer.parse |> elem(0)

    ^size = byte_size(tree_contents)
    [contents_head | tree_contents] = tree_contents |> String.split(<<0>>)

    tree = %Exit.Tree{tree | size: size}

    new_contents = tree_contents
    |> Enum.reduce({contents_head, []}, fn(x, {part, acc}) ->
      case x do
        << sha_for_part :: binary-size(20), next_part :: binary >> ->
          {next_part, [part <> <<0>> <> sha_for_part | acc]}
        << sha_for_part :: binary-size(20) >> ->
          {"", [part <> <<0>> <> sha_for_part | acc]}
        _ ->
          {"", acc}
      end
    end)
    |> elem(1) |> Enum.map(fn(x) ->
      [mode_and_filename, sha] = x |> String.split(<<0>>)
      [mode, filename] = String.split(mode_and_filename)
      %Exit.TreeEntry{id: Base.encode16(sha) |> String.downcase, mode: mode, filename: filename}
    end) |> Enum.sort_by &(Map.fetch(&1, :filename))

    tree = %Exit.Tree{tree | contents: new_contents}
    {:ok, tree}
  end
end
