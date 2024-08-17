defmodule JustrunitWeb.Modules.Accounts.SettingsLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

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
            <label class="text-sm text-zinc-500">Computing Hours</label>
            <p class="text-2xl font-bold">40 / 50</p>
          </div>
          <div class="w-px bg-gray-300"></div>
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">vCPUs</label>
            <p class="text-2xl font-bold">4</p>
          </div>
          <div class="w-px bg-gray-300"></div>
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">RAM</label>
            <p class="text-2xl font-bold">2 GBs</p>
          </div>
          <div class="w-px bg-gray-300"></div>
          <div class="flex flex-col items-center w-1/4 text-center">
            <label class="text-sm text-zinc-500">Storage</label>
            <p class="text-2xl font-bold">50 GBs</p>
          </div>
        </div>
        <p class="mx-auto">Plan: <span class="font-bold">Paid</span></p>
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
    user = Repo.get!(User, socket.assigns.current_user.id)
    form = to_form(User.settings_changeset(user, %{}))

    socket =
      socket
      |> assign(form: form)

    {:ok, socket}
  end

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
