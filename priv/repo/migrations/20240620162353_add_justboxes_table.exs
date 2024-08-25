defmodule Justrunit.Repo.Migrations.AddJustboxesTable do
  use Ecto.Migration

  def change do
    create table(:justboxes) do
      add :name, :string, null: false, unique: true
      add :slug, :string, null: false, unique: true
      add :description, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :s3_key, :string, null: false
      timestamps()
    end

    create unique_index(:justboxes, [:s3_key])
    create(index(:justboxes, [:user_id]))
  end
end
