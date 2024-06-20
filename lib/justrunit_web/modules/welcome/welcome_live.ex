defmodule JustrunitWeb.Modules.Welcome.WelcomeLive do
 use Phoenix.LiveView

 def render(assigns) do
    ~H"""
    <div>
    <header class="flex flex-col items-center">
      <h1 class="text-4xl font-bold mt-24">Simple tool for sharing code</h1>
      <h2 class="text-xl py-4">Easy interface, faster development</h2>
      <a href="/sign-up" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition">Just Try It</a>
      <p class="text-gray-700 text-sm">No credit card required</p>
      </header>
      <section class="flex flex-col items-center mt-72 bg-gray-300">
        <h3>Playground</h3>
      </section>
    </div>
    """
  end

  def mount(params, session, socket) do
    {:ok, socket, layout: {JustrunitWeb.Layouts, :guest}}
  end
end
