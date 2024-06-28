defmodule JustrunitWeb.Modules.Accounts.SettingsLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="save"
      phx-change="validate"
      class="flex flex-col max-w-sm mx-auto mt-12 gap-8"
    >
      <.breadcrumb items={[%{label: "justboxes", navigate: "/justboxes/"}, %{text: "Settings"}]} />
      <h1 class="text-2xl font-bold text-center">Settings</h1>
      <.input field={@form[:name]} label="Name" type="text" class="w-full" />
      <.input field={@form[:handle]} label="Handle" type="text" class="w-full" />
      <.button type="submit" class="mt-4">Update</.button>
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
