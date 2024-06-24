defmodule Justrunit.Repo.Migrations.DisableNullInJustboxesUserId do
  use Ecto.Migration

  def change do
    alter table(:justboxes) do
      modify :user_id, :integer, null: false
    end
  end
end
