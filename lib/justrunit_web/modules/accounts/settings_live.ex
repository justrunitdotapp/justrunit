defmodule JustrunitWeb.Modules.Accounts.SettingsLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  @seconds_in_hour 3600

  def render(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="save"
      phx-change="validate"
      class="flex flex-col gap-8 mx-auto my-12 max-w-sm lg:max-w-2xl"
    >
      <.breadcrumb items={[%{label: "justboxes", navigate: "/justboxes/"}, %{text: "Settings"}]} />
      <h1 class="text-2xl font-bold text-center">Account details</h1>
      <.input field={@form[:name]} label="Name" type="text" class="w-full" />
      <.input field={@form[:handle]} label="Handle" type="text" class="w-full" />
      <.button type="submit" class="mt-4 lg:w-24 lg:ml-auto">Update</.button>
      <section class="flex flex-col gap-8">
        <h2 class="text-xl font-bold text-center">Rented resources</h2>
        <div class="flex">
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">Computing <%= @time_unit %></label>
            <p class="text-2xl font-bold"><%= @computing_time %> / <%= @max_computing_time %></p>
            <p class="text-xs text-zinc-500">
              <%= @computing_time_seconds %> / <%= @max_computing_time_seconds %> sec
            </p>
          </div>
          <div class="w-px bg-gray-300"></div>
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">vCPUs</label>
            <p class="text-2xl font-bold"><%= @vcpus %></p>
          </div>
          <div class="w-px bg-gray-300"></div>
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">RAM</label>
            <p class="text-2xl font-bold"><%= @ram %> GBs</p>
          </div>
          <div class="w-px bg-gray-300"></div>
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">Storage</label>
            <p class="text-2xl font-bold"><%= @storage %> GBs</p>
          </div>
        </div>
        <p class="mx-auto">Plan: <span class="font-bold"><%= @plan_type %></span></p>
        <.link class="mx-auto text-blue-500 hover:underline" href={~p"/settings/change-allowance"}>
          Change allowance
        </.link>
        <.input type="checkbox" field={@form[:auto_renew]} label="Auto-renew" class="w-full" />
        <.button type="submit" class="mt-4 lg:w-24 lg:ml-auto">Update</.button>
      </section>
    </.form>
    """
  end

  alias JustrunitWeb.Modules.Accounts.User
  alias Justrunit.Repo

  def mount(_, _session, socket) do
    user =
      Repo.get_by(User, id: socket.assigns.current_user.id)
      |> Repo.preload(user_plan: :plan)

    form = to_form(User.settings_changeset(user, %{}))

    socket =
      socket
      |> assign(form: form)
      |> assign(vcpus: user.user_plan.plan.vcpus)
      |> assign(ram: user.user_plan.plan.ram)
      |> assign(storage: user.user_plan.plan.storage)
      |> assign(plan_type: user.user_plan.plan.type)
      |> assign(
        computing_time:
          calculate_computing_time(user.user_plan.plan.computing_seconds |> Decimal.to_integer())
      )
      |> assign(computing_time_seconds: 1)
      |> assign(
        max_computing_time_seconds: user.user_plan.plan.computing_seconds |> Decimal.to_integer()
      )
      |> assign(
        time_unit: time_unit(user.user_plan.plan.computing_seconds |> Decimal.to_integer())
      )
      |> assign(
        max_computing_time:
          div(user.user_plan.plan.computing_seconds |> Decimal.to_integer(), 3600)
      )

    {:ok, socket}
  end

  defp calculate_computing_time(seconds) when seconds < @seconds_in_hour, do: "<1"
  defp calculate_computing_time(seconds) when seconds > @seconds_in_hour, do: div(seconds, 3600)

  defp time_unit(seconds) when seconds >= @seconds_in_hour, do: "Hours"
  defp time_unit(seconds) when seconds < @seconds_in_hour, do: "Minutes"

  def handle_event("validate", %{"user" => user_params}, socket) do
    user = Repo.get!(User, socket.assigns.current_user.id)
    changeset = User.settings_changeset(user, user_params)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user = Repo.get!(User, socket.assigns.current_user.id)
    changeset = User.settings_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        socket = socket |> put_flash(:info, "Settings updated")
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
