defmodule Justrunit.Repo.Migrations.JustboxesChangeS3UrlToS3Key do
  use Ecto.Migration

  def change do
    alter table(:justboxes) do
      remove(:s3_url)
      add(:s3_key, :string, null: false)
    end
  end
end
