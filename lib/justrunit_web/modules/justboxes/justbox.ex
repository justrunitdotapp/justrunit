defmodule JustrunitWeb.Modules.Justboxes.Justbox do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    sortable: [:updated_at],
    filterable: []
  }

  schema "justboxes" do
    field :name, :string
    field :slug, :string
    field :description, :string
    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:name, :slug, :description])
    |> validate_required([:name, :slug, :description])
  end
end
