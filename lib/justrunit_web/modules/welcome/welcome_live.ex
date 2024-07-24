defmodule JustrunitWeb.Modules.Welcome.WelcomeLive do
  use JustrunitWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <header class="flex flex-col items-center">
        <h1 class="mt-24 text-4xl font-bold">Simple tool for sharing code</h1>
        <h2 class="py-4 text-xl">Easy interface, faster development</h2>
        <a
          href="/sign-up"
          class="px-4 py-2 font-bold text-white bg-blue-500 rounded transition hover:bg-blue-700"
        >
          Just Try It
        </a>
        <p class="text-sm text-gray-700">No credit card required</p>
      </header>
      <div class="mx-auto mt-72 max-w-7xl">
        <h2 class="text-3xl font-medium text-center">Interactive Playground</h2>
        <!-- <.svelte
          name="Jeditor"
          props={%{s3_keys: @s3_keys, justbox_name: @justbox_name}}
          socket={@socket}
        /> -->
      </div>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Justboxes.ShowJustboxLive

  def mount(params, session, socket) do
    {:ok, socket, layout: {JustrunitWeb.Layouts, :guest}}
  end

  def handle_params(params, _uri, socket) do
    {justbox_name, s3_keys} = ShowJustboxLive.load_justbox("user1", "test", socket)

    socket = socket |> assign(justbox_name: justbox_name, s3_keys: s3_keys)
    {:noreply, socket}
  end
end
