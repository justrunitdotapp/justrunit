defmodule Justrunit do
  @moduledoc """
  Justrunit keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Converts a string into URL friendly slug
  """
  def slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\-]/, "-")
    |> String.replace_prefix("#{String.at(str, 0)}-", "")
    |> String.trim()
  end
end
