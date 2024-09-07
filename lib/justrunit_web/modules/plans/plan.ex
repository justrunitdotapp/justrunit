defmodule JustrunitWeb.Modules.Plans.Plan do
  use Ecto.Schema
  import Ecto.Changeset
  alias Justrunit.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "plans" do
    field :vcpus, :integer
    field :ram, :integer
    field :storage, :integer
    field :remaining_computing_seconds, :decimal
    field :computing_seconds_limit, :decimal
    field :type, Ecto.Enum, values: [:static, :dynamic]
    field :paid, :boolean, default: true
    field :description, :string, default: ""

    has_many :users, JustrunitWeb.Modules.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [
      :vcpus,
      :ram,
      :storage,
      :type,
      :paid,
      :remaining_computing_seconds,
      :computing_seconds_limit,
      :description
    ])
    |> validate_required([
      :vcpus,
      :ram,
      :storage,
      :type,
      :paid,
      :remaining_computing_seconds,
      :computing_seconds_limit,
      :description
    ])
    |> validate_inclusion(:type, [:static, :dynamic])
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
    |> Ecto.Changeset.validate_number(:remaining_computing_seconds,
      greater_than_or_equal_to: 0,
      message: "Computing seconds can't be negative."
    )
    |> Ecto.Changeset.validate_number(:computing_seconds_limit,
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
