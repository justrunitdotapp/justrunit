defmodule JustrunitWeb.Modules.Accounts.SettingsLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="save"
      phx-change="validate"
      class="flex flex-col max-w-sm lg:max-w-2xl mx-auto my-12 gap-8"
    >
      <.breadcrumb items={[%{label: "justboxes", navigate: "/justboxes/"}, %{text: "Settings"}]} />
      <h1 class="text-2xl font-bold text-center">Account details</h1>
      <.input field={@form[:name]} label="Name" type="text" class="w-full" />
      <.input field={@form[:handle]} label="Handle" type="text" class="w-full" />
      <.button type="submit" class="mt-4 lg:w-24 lg:ml-auto">Update</.button>
      <section class="flex flex-col gap-8">
        <h2 class="text-xl font-bold text-center">Rented resources</h2>
        <div>
          <h3 class="text-lg font-bold">Usage</h3>
          <ul class="list-none space-y-2 mb-6">
            <li class="text-gray-700">
              vCPUs: 0% / 200%
              <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                <div class="bg-blue-600 h-2.5 rounded-full" style="width: 2%"></div>
              </div>
            </li>
            <li class="text-gray-700">
              Storage: 0 / 0.2 GB
              <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                <div class="bg-blue-600 h-2.5 rounded-full" style="width: 2%"></div>
              </div>
            </li>
          </ul>
        </div>
        <div>
          <.input field={@form[:storage]} label="Storage (GB)" type="number" class="w-full" />
          <p class="text-gray-7000 text-sm">$0.00 per month</p>
        </div>
        <div>
          <.input field={@form[:vcpus]} label="vCPUs" type="number" class="w-full" />
          <p class="text-gray-7000 text-sm">$0.00 per month</p>
        </div>
        <p class="text-gray-700 font-bold">Monthly Cost: $0.00</p>
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

    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
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
