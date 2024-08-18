defmodule JustrunitWeb.Modules.Accounts.Plans.Plan do
  use Ecto.Schema
  import Ecto.Changeset

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
  Checks if changed plan is paid at the end
  """
  def update(struct \\ %__MODULE__{}, params) do
    cs = changeset(struct, params)

    if plan_is_paid?(struct) do
      change(struct, %{type: :paid})
    else
      struct
    end
  end


  @doc """
  Checks if a plan is paid based on resources allowance
  """
  def plan_is_paid?(new_plan) do
    case Repo.get(Plan, 0) do
      {:ok, plan} ->
        Enum.all?(
          [:vcpus, :ram, :storage, :computing_seconds],
          fn key ->
            new_plan.data[key] > plan.data[key]
          end
        )

      {:error, _} ->
        {:error, :failed_to_find_free_plan}
    end
  end
end
