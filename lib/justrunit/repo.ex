defmodule Justrunit.Repo do
  use Ecto.Repo,
    otp_app: :justrunit,
    adapter: Ecto.Adapters.Postgres
end
