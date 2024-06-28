defmodule JustrunitWeb.Modules.Pricing.PricingLive do
  use JustrunitWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="max-w-5xl text-blue-500 mx-auto">
      <h2 class="text-4xl font-bold  mb-4 text-center mt-16 pb-2">
        Simple, predictable pricing.
      </h2>
      <p class="text-xl text-gray-700 text-center mb-6">
        No additional fees, no auto-renewals on default, simple cancellation.
      </p>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-24">
        <div class="rounded-lg p-8 flex flex-col justify-between">
          <h2 class="text-3xl font-bold text-blue-500 mb-4">For newcomers</h2>
          <p class="text-lg text-gray-700 mb-6">
            So they can speed up development process and learning for 0$ with our free plan.
          </p>
          <ul class="list-none space-y-2 mb-6">
            <li class="text-gray-700">✔ All the features</li>
            <li class="text-gray-700">✔ 2 Free virtual processors</li>
            <li class="text-gray-700">✔ 200 MB of storage</li>
          </ul>
          <.link
            class="bg-blue-500 text-white px-6 py-3 rounded-md hover:bg-blue-600 transition-colors mx-auto"
            phx-click="sign_up_free"
          >
            Sign Up for Free
          </.link>
        </div>
        <div class="rounded-lg p-8 flex flex-col justify-between">
          <h2 class="text-3xl font-bold text-blue-500 mb-4">For those who need more</h2>
          <p class="text-lg text-gray-700 mb-6">And don't want to be ripped off.</p>
          <ul class="list-none space-y-2 mb-6">
            <li class="text-gray-700">✔ Everything in the free plan</li>
            <li class="text-gray-700">✔ 1 virtual processor for 0.50$</li>
            <li class="text-gray-700">✔ 1 GB of storage for 1$</li>
          </ul>
          <button
            class="bg-blue-500 text-white px-6 py-3 rounded-md hover:bg-blue-600 transition-colors w-36 mx-auto"
            phx-click="upgrade_pro"
          >
            Go Pro
          </button>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {JustrunitWeb.Layouts, :guest}}
  end
end
