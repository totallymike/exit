defmodule Exit.ObjectDB do
  def add(contents, type) do
    Exit.Object.hash_w(contents, type)
  end

  def add_blob(contents) do
    Exit.ObjectDB.add(contents, "blob")
  end

  def fetch(id) do
    {folder, filename} = String.split_at(id, 2)
    object = File.read!(".git/objects/#{folder}/#{filename}")
    Exit.Object.from_binary(:zlib.uncompress object)
  end
end
