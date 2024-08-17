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
alias JustrunitWeb.Modules.Accounts.Plans.Plan

Repo.insert!(%Plan{vcpus: 1, ram: 1, storage: 1, computing_seconds: 1, type: :free})
