defmodule JustrunitWeb.Modules.Accounts.SettingsLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
      <.form for={@form} phx-submit="update" class="flex flex-col max-w-sm mx-auto mt-12 gap-8">
        <.breadcrumb items={[%{label: "justboxes", navigate: "/justboxes/1"}, %{text: "Settings"}]} />
        <h1 class="text-2xl font-bold text-center">Settings</h1>
        <.input field={@form[:name]} label="Name" type="text" class="w-full" />
        <.input field={@form[:handle]} label="Handle" type="text" class="w-full" />
        <.button type="submit" class="mt-4">Update</.button>
      </.form>
    """
  end

  alias JustrunitWeb.Modules.Accounts.User
  def mount(_, _session, socket) do
    form = to_form(JustrunitWeb.Modules.Accounts.User.registration_changeset(%User{}, %{}))
    {:ok, assign(socket, form: form), layout: {JustrunitWeb.Layouts, :app}}
  end
end
