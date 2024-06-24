defmodule Justrunit.Repo.Migrations.AddUserRelationshipToJustbox do
  use Ecto.Migration

  def change do
    alter table(:justboxes) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    alter table(:users) do
      add :name, :string, null: false
      add :handle, :string, null: false, unique: true
    end

    create(unique_index(:users, [:handle]))
    create(index(:justboxes, [:user_id]))
  end
end
