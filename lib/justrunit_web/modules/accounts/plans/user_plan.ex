defmodule JustrunitWeb.Modules.Accounts.Plans.UserPlan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_plan" do
    belongs_to :user, JustrunitWeb.Modules.Accounts.User
    belongs_to :plan, JustrunitWeb.Modules.Accounts.Plans.Plan

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(struct \\ %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, [:user_id, :plan_id])
    |> validate_required([:user_id, :plan_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:plan_id)
    |> unique_constraint([:user_id, :plan_id])
  end
end
