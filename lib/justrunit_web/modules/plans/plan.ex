defmodule JustrunitWeb.Modules.Plans.Plan do
  use Ecto.Schema
  import Ecto.Changeset
  alias Justrunit.Repo

  schema "plans" do
    field :vcpus, :integer
    field :ram, :integer
    field :storage, :integer
    field :computing_seconds, :decimal
    field :type, Ecto.Enum, values: [:free, :paid]

    has_many :users, JustrunitWeb.Modules.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:vcpus, :ram, :storage, :type, :computing_seconds])
    |> validate_required([:vcpus, :ram, :storage, :type, :computing_seconds])
    |> validate_inclusion(:type, [:free, :paid])
    |> Ecto.Changeset.validate_number(:vcpus,
      greater_than_or_equal_to: 0,
      message: "You can't have negative vcpus."
    )
    |> Ecto.Changeset.validate_number(:ram,
      greater_than_or_equal_to: 0,
      message: "You can't have negative ram."
    )
    |> Ecto.Changeset.validate_number(:storage,
      greater_than_or_equal_to: 0,
      message: "You can't have negative storage."
    )
    |> Ecto.Changeset.validate_number(:computing_seconds,
      greater_than_or_equal_to: 0,
      message: "Computing seconds can't be negative."
    )
  end

  @doc """
  Checks if a plan is paid based on resources allowance
  """
  def plan_is_paid?(new_plan) do
    case Repo.get(JustrunitWeb.Modules.Plans.Plan, 1) do
      nil ->
        {:error, :failed_to_find_free_plan}

      plan ->
        new_plan_keys = Map.keys(new_plan)

        if Map.take(plan, new_plan_keys) == new_plan do
          false
        else
          true
        end
    end
  end
end
