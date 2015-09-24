defmodule Exit.Object do
  defstruct id: nil, type: nil, size: nil, contents: nil

  def from_binary(bin) do
    [type_and_size, contents] = String.split(bin, <<0>>, parts: 2)
    [type, size] = String.split(type_and_size, " ")
    object = %__MODULE__{type: type, size: size, contents: contents}
    %__MODULE__{object | id: hash(contents, type)}
  end

  def hash(content, type \\ "blob") do
    blob = store(content, type)

    :crypto.hash(:sha, blob)
    |> Base.encode16(case: :lower)
  end

  def header(content, type) do
    "#{type} #{content_size(content)}\0"
  end

  def store(content, type) do
    "#{type} #{content_size(content)}\0" <> content
  end

  def hash_w(content, type) do
    id = hash(content)
    {folder, filename} = String.split_at(id, 2)
    File.mkdir_p! ".git/objects/#{folder}"

    {:ok, _} = File.open ".git/objects/#{folder}/#{filename}", [:write], fn(file) ->
      IO.binwrite(file, :zlib.compress(store(content, "blob")))
    end
    {:ok, id}
  end

  defp content_size(content) do
    "#{Kernel.byte_size(content)}"
  end
end
