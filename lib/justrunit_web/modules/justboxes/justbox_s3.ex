defmodule JustrunitWeb.Modules.Justboxes.JustboxS3 do
    alias Justrunit.S3

  def put_object(key, content, opts \\ []) do
    S3.put_object("justboxes/#{key}")
  end

  def list_objects_by_prefix(prefix) do
    S3.list_objects_by_prefix(prefix)
  end
end