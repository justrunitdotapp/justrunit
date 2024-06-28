defmodule JustrunitWeb.Modules.Accounts.SignInLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.CoreComponents, only: [form: 2, input: 1]

  def render(assigns) do
    ~H"""
    <div class="w-96 mx-auto mt-48 rounded-xl">
      <h1 class="text-2xl font-bold text-center">Sign In</h1>
      <p class="text-center py-2">
        Click
        <.link navigate={~p"/sign-up"} class="text-blue-500 hover:underline text-lg">here</.link>
        if you don't have an account
      </p>
      <.form for={@form} phx-submit="save" action={~p"/sign_in"} class="space-y-8">
        <.input
          field={@form[:email]}
          type="email"
          label="Email"
          class="w-full p-2 border-2 border-blue-500 rounded-lg"
        />
        <div>
          <.input
            field={@form[:password]}
            label="Password"
            type="password"
            class="w-full p-2 border-2 border-blue-500 rounded-lg"
          />
          <p class="text-sm">
            Forgot your password?
            <.link navigate={~p"/reset_password"} class="text-blue-500 hover:underline">
              Reset it here
            </.link>
          </p>
        </div>
        <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
        <button
          type="submit"
          phx-disable-with="Logging in..."
          class="bg-blue-500 text-white px-4 py-2 rounded-lg font-semibold hover:bg-blue-600 transition w-full"
        >
          Log in
        </button>
      </.form>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Accounts.User

  def mount(_params, _session, socket) do
    form =
      to_form(User.registration_changeset(%User{}, %{}))

    socket = socket |> assign(form: form)
    {:ok, socket, layout: false}
  end

  def handle_event("save", %{"user" => params}, socket) do
    {:noreply, socket}
  end
end
