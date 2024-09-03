defmodule JustrunitWeb.Modules.Accounts.ProfileS3 do
  alias Justrunit.S3

  @prefix "profiles"

  def put_object(key, content, opts \\ []) do
    S3.put_object("#{@prefix}/#{key}", content, opts)
  end
end
