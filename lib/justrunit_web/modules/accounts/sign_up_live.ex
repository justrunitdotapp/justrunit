defmodule JustrunitWeb.Modules.Accounts.SignUpLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.CoreComponents, only: [input: 1]

  def render(assigns) do
    ~H"""
    <div class="w-96 mx-auto mt-48 rounded-xl">
      <h1 class="text-2xl font-bold text-center">New Account</h1>
      <p class="text-center py-2">Click <.link patch="/sign-in" class="text-blue-500 hover:underline text-lg">here</.link> to sign in</p>
      <.form for={@form} phx-submit="save" class="space-y-10">
        <.input field={@form[:email]} type="email" label="Email" class="w-full p-2 border-2 border-blue-500 rounded-lg" />
        <.input field={@form[:password]} label="Password" type="password" class="w-full p-2 border-2 border-blue-500 rounded-lg" />
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded-lg font-semibold hover:bg-blue-600 transition w-full">Register</button>
      </.form>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Accounts.User

  def mount(_params, _session, socket) do
    form =
      to_form(User.changeset(%User{}, %{}))

    socket = socket |> assign(form: form)
    {:ok, socket, layout: false}
  end

  def handle_event("save", %{"user" => params}, socket) do
    {:noreply, socket}
  end
end
