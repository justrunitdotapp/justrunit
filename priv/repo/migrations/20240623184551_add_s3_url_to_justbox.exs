defmodule Justrunit.Repo.Migrations.AddS3UrlToJustbox do
  use Ecto.Migration

  def change do
    alter table(:justboxes) do
      add :s3_url, :string, null: false, unique: true
    end

    create unique_index(:justboxes, [:s3_url])
  end
end
