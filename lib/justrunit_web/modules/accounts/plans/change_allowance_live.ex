defmodule JustrunitWeb.Modules.Accounts.Plans.ChangeAllowanceLive do
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
      <.input field={@form[:vcpus]} label="vCPUs" type="text" class="w-full" />
      <.input field={@form[:ram]} label="RAM" type="text" class="w-full" />
      <.input field={@form[:storage]} label="Storage (In GBs)" type="text" class="w-full" />
      <.button type="submit" class="mt-4 lg:w-24 lg:ml-auto">Update</.button>
    </.form>
    """
  end

  alias JustrunitWeb.Modules.Accounts.User
  alias JustrunitWeb.Modules.Accounts.Plans.Plan
  alias Justrunit.Repo

  def mount(_, _session, socket) do
    user = Repo.get_by(User, id: socket.assigns.current_user.id)
       |> Repo.preload([user_plan: :plan])

    form = to_form(Plan.changeset(user.user_plan.plan, %{}))
    socket = socket |> assign(form: form)

    {:ok, socket}
  end

  def handle_event("save", %{"plan" => plan_params}, socket) do
    user =
      Repo.get_by(User, id: socket.assigns.current_user.id)
      |> Repo.preload([user_plan: :plan])

    changeset = Plan.update(user.user_plan.plan, plan_params)

    case Repo.update(changeset) do
      {:ok, res} ->
        socket = socket |> put_flash(:info, "Allowance updated")
        {:noreply, socket}

      {:error, reason} ->
        IO.inspect(reason)
        socket = socket |> put_flash(:error, "Failed to update allowance")
        {:noreply, socket}
    end
  end
end
