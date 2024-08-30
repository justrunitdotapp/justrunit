defmodule JustrunitWeb.Modules.Plans.ChangeAllowanceLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="save"
      class="flex flex-col gap-8 mx-auto my-12 max-w-sm lg:max-w-2xl"
    >
      <.breadcrumb items={[
        %{label: "justboxes", navigate: "/justboxes/"},
        %{text: "Settings", navigate: "/settings/"},
        %{text: "Change Allowance"}
      ]} />
      <h1 class="text-2xl font-bold text-center">Change Allowance</h1>
      <p class="text-lg font-medium text-center text-zinc-800">
        Current plan:
        <%= if @form.data.paid do %>
          Paid
        <% else %>
          Free
        <% end %>
      </p>
      <.input field={@form[:vcpus]} label="vCPUs" type="text" class="w-full" />
      <.input field={@form[:ram]} label="RAM" type="text" class="w-full" />
      <.input field={@form[:storage]} label="Storage (In GBs)" type="text" class="w-full" />
      <.input
        field={@form[:computing_seconds_limit]}
        label="Storage (In Hours)"
        type="text"
        class="w-full"
      />
      <.button type="submit" class="mt-4 lg:w-24 lg:ml-auto">Update</.button>
    </.form>
    """
  end

  alias JustrunitWeb.Modules.Accounts.User
  alias JustrunitWeb.Modules.Plans.Plan
  alias Justrunit.Repo
  alias Ecto.Multi

  import Ecto.Query

  def mount(_, _session, socket) do
    user =
      Repo.get(User, socket.assigns.current_user.id)
      |> Repo.preload(:plan)

    form = to_form(Plan.changeset(user.plan, %{}))
    socket = socket |> assign(form: form)

    {:ok, socket}
  end

  def handle_event("save", %{"plan" => plan_params}, socket) do
    case Plan.plan_is_paid?(plan_params) do
      true ->
        plan_params = plan_params |> Map.put("type", :dynamic) |> Map.put("paid", true)
        changeset = Plan.changeset(%Plan{}, plan_params)

        planrel_or_rel(plan_params, socket.assigns.current_user.id)
        |> case do
          {:ok, _} ->
            socket = socket |> put_flash(:info, "Allowance updated")
            {:noreply, socket}

          {:error, _} ->
            socket = socket |> put_flash(:error, "Failed to update allowance")
            {:noreply, socket}
        end

      false ->
        {:noreply, socket}

      {:error, :failed_to_find_free_plan} ->
        socket = socket |> put_flash(:error, "Failed to update allowance")
        {:noreply, socket}
    end
  end

  @doc """
  Checks if there is a plan with given fields and then creates a plan with a relationship to user or just a relationship if a plan already exists.
  """
  def planrel_or_rel(attrs, user_id) do
    attrs =
      attrs
      |> Enum.map(fn
        {key, value} when is_binary(key) -> {String.to_existing_atom(key), value}
        {key, value} -> {key, value}
      end)
      |> Map.new()

    case Repo.get_by(Plan, attrs) do
      nil ->
        Repo.transaction(fn ->
          user = Repo.get!(User, user_id) |> Repo.preload(:plan)

          attrs =
            Map.put(attrs, :remaining_computing_seconds, user.plan.remaining_computing_seconds)

          new_plan = Plan.changeset(%Plan{}, attrs) |> Repo.insert!()
          old_plan_id = user.plan.id

          old_plan_type =
            user.plan.type

          # Step 3: Create a new relationship between the user and the new plan
          User.change_plan_changeset(user, %{plan_id: new_plan.id})
          |> Repo.update!()

          # Step 4: Check if the old plan has any remaining users

          remaining_users =
            Repo.aggregate(
              from(u in User, where: u.plan_id == ^old_plan_id),
              :count
            )

          # Step 5: If no users are left, remove the old plan
          if remaining_users == 0 and old_plan_type == :dynamic do
            Repo.get!(Plan, user.plan.id) |> Repo.delete!()
          end

          # Return the user and new plan for confirmation
          {:ok, :ok}
        end)

      existing_plan ->
        Repo.transaction(fn ->
          user = Repo.get!(User, user_id) |> Repo.preload(:plan)
          old_plan_id = user.plan.id
          old_plan_type = user.plan.type

          # Step 3: Create a new relationship between the user and the new plan
          User.change_plan_changeset(user, %{plan_id: existing_plan.id})
          |> Repo.update!()

          # Step 5: Check if the old plan has any remaining users

          remaining_users =
            Repo.aggregate(
              from(u in User, where: u.plan_id == ^old_plan_id),
              :count
            )

          # Step 6: If no users are left, remove the old plan
          if remaining_users == 0 and old_plan_type == :dynamic do
            Repo.get!(Plan, old_plan_id) |> Repo.delete!()
          end

          # Return the user and new plan for confirmation
          {:ok, :ok}
        end)
    end
  end
end
