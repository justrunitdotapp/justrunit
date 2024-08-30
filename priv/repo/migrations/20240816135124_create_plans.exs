defmodule Justrunit.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def up do
    # Create plans table
    create table(:plans) do
      add :vcpus, :integer, null: false
      add :ram, :integer, null: false
      add :storage, :integer, null: false
      add :remaining_computing_seconds, :decimal, precision: 20, scale: 10, null: false
      add :computing_seconds_limit, :decimal, precision: 20, scale: 10, null: false
      add :type, :string, null: false
      add :paid, :boolean, default: false, null: false
      timestamps(type: :utc_datetime)
    end

    # Add constraints
    create constraint(:plans, :positive_vcpus, check: "vcpus > 0")
    create constraint(:plans, :positive_ram, check: "ram > 0")
    create constraint(:plans, :positive_storage, check: "storage > 0")

    create constraint(:plans, :positive_ramining_computing_seconds,
             check: "remaining_computing_seconds > 0"
           )

    create constraint(:plans, :positive_computing_seconds_limit,
             check: "computing_seconds_limit > 0"
           )

    create unique_index(:plans, [:vcpus, :ram, :storage, :computing_seconds_limit, :type])

    # type needs to be in unique_index because some a paid plan might have the same values as some other free one

    # Create enum type and alter plans table
    execute "CREATE TYPE plan_type AS ENUM ('static', 'dynamic')"
    execute "ALTER TABLE plans ALTER COLUMN type TYPE plan_type USING (type::plan_type)"

    alter table(:users) do
      add :plan_id, references(:plans, on_delete: :restrict), null: false
    end
  end

  def down do
    drop table(:plans)
    execute "DROP TYPE plan_type"
    execute "ALTER TABLE users ALTER COLUMN type TYPE varchar(255)"
  end
end
