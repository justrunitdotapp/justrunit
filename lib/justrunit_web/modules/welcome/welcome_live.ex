defmodule JustrunitWeb.Modules.Welcome.WelcomeLive do
  use JustrunitWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="flex justify-around mt-24">
      <header class="flex flex-col">
        <h1 class="mt-24 text-4xl font-bold">Simple tool for sharing code</h1>
        <h2 class="py-4 text-xl">Easy interface, faster development</h2>
        <a
          href="/sign-up"
          class="px-4 py-2 mx-auto mt-8 font-bold text-white bg-blue-500 rounded transition hover:bg-blue-700"
        >
          Just Try It
        </a>
        <p class="mx-auto text-sm text-gray-700">No credit card required</p>
      </header>
      <div>
        <iframe
          width="720"
          height="480"
          class="mx-auto"
          src="https://www.youtube.com/embed/VIDEO_ID"
          frameborder="0"
          allowfullscreen
        >
        </iframe>
      </div>
    </section>

    <section class="mx-auto mt-24 max-w-7xl">
      <h2 class="text-3xl font-medium text-center">Interactive Playground</h2>
      <!-- <.svelte
          name="Jeditor"
          props={%{s3_keys: @s3_keys, justbox_name: @justbox_name}}
          socket={@socket}
        /> -->
    </section>
    <section class="mx-auto max-w-5xl text-blue-500">
      <h2 class="pb-2 mt-16 mb-4 text-4xl font-bold text-center">
        Simple, predictable pricing.
      </h2>
      <p class="mb-6 text-xl text-center text-gray-700">
        No additional fees, no auto-renewals on default, simple cancellation.
      </p>
      <.svelte name="Pricing/Pricing" props={%{recommendedValue: 25}} socket={@socket} />
    </section>
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
