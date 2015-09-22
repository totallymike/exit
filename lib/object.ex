defmodule Exit.Object do
  def hash(content, content_type \\ "blob") do
    blob = store(content, content_type)

    :crypto.hash(:sha, blob)
    |> Base.encode16(case: :lower)
  end

  def header(content, content_type) do
    "#{content_type} #{content_size(content)}\0"
  end

  def store(content, content_type) do
    "#{content_type} #{content_size(content)}\0" <> content
  end

  def hash_w(content) do
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
