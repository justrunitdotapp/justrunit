# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Justrunit.Repo.insert!(%Justrunit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Justrunit.Repo
alias JustrunitWeb.Modules.Rap
alias JustrunitWeb.Modules.Rap.Role

for role <- Rap.DefaultRoles.all() do
  unless Repo.get_by(Role, name: role.name) do
    Role.changeset(%Role{}, role) |> Repo.insert!()
  end
end

alias JustrunitWeb.Modules.Plans.Plan
import Ecto.Query

query = from(p in Plan, where: p.description == "default")

unless Repo.exists?(query) do
  Plan.changeset(%Plan{}, %{
    vcpus: 1,
    ram: 1,
    storage: 1,
    remaining_computing_seconds: 1,
    computing_seconds_limit: 1,
    type: "static",
    paid: false,
    description: "default"
  })
  |> Repo.insert!()
end
