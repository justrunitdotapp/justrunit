defmodule Justrunit.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :vcpus, :integer, null: false
      add :ram, :integer, null: false
      add :storage, :integer, null: false
      add :computing_seconds, :decimal, precision: 20, scale: 10, null: false
      add :type, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create constraint(:plans, :positive_vcpus, check: "vcpus > 0")
    create constraint(:plans, :positive_ram, check: "ram > 0")
    create constraint(:plans, :positive_storage, check: "storage > 0")
    create constraint(:plans, :positive_computing_seconds, check: "computing_seconds > 0")


    create table(:user_plan) do
      add :plan_id, references(:plans, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_plan, [:user_id])
    create index(:user_plan, [:plan_id])
    create unique_index(:user_plan, [:user_id, :plan_id])
  end

  def change() do
    # Execute custom SQL for creating enum type and altering table
    execute "CREATE TYPE plan_type AS ENUM ('paid', 'free')"
    execute "ALTER TABLE users ALTER COLUMN type TYPE plan_type USING (type::plan_type)"
  end
end