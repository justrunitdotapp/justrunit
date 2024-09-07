defmodule Justrunit.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false, unique: true
      add :permissions, :jsonb, null: false

      timestamps(type: :utc_datetime)
    end

    alter table(:users) do
      add :role_id, references(:roles, type: :binary_id, on_delete: :restrict), null: false
    end
  end
end
