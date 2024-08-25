defmodule Justrunit.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def up do
    # Create plans table
    create table(:plans) do
      add :vcpus, :integer, null: false
      add :ram, :integer, null: false
      add :storage, :integer, null: false
      add :computing_seconds, :decimal, precision: 20, scale: 10, null: false
      add :type, :string, null: false
      timestamps(type: :utc_datetime)
    end

    # Add constraints
    create constraint(:plans, :positive_vcpus, check: "vcpus > 0")
    create constraint(:plans, :positive_ram, check: "ram > 0")
    create constraint(:plans, :positive_storage, check: "storage > 0")
    create constraint(:plans, :positive_computing_seconds, check: "computing_seconds > 0")
    create unique_index(:plans, [:vcpus, :ram, :storage, :computing_seconds, :type])

    # type needs to be in unique_index because some a paid plan might have the same values as some other free one

    # Create user_plan table
    create table(:user_plan) do
      add :plan_id, references(:plans, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:user_plan, [:plan_id])

    # Insert initial data
    execute "INSERT INTO plans (vcpus, ram, storage, computing_seconds, type, inserted_at, updated_at) VALUES (1, 1, 1, 1, 'free', NOW(), NOW())"
    # Create enum type and alter plans table
    execute "CREATE TYPE plan_type AS ENUM ('paid', 'free')"
    execute "ALTER TABLE plans ALTER COLUMN type TYPE plan_type USING (type::plan_type)"
  end

  def down do
    drop table(:user_plan)
    drop table(:plans)
    execute "DROP TYPE plan_type"
    execute "ALTER TABLE users ALTER COLUMN type TYPE varchar(255)"
  end
end
