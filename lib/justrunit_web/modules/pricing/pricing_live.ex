defmodule JustrunitWeb.Modules.Pricing.PricingLive do
  use JustrunitWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-5xl text-blue-500">
      <h2 class="pb-2 mt-16 mb-4 text-4xl font-bold text-center">
        Simple, predictable pricing.
      </h2>
      <p class="mb-6 text-xl text-center text-gray-700">
        No additional fees, no auto-renewals on default, simple cancellation.
      </p>
      <div class="grid grid-cols-1 gap-24 md:grid-cols-2">
        <div class="flex flex-col justify-between p-8 rounded-lg">
          <h2 class="mb-4 text-3xl font-bold text-blue-500">For newcomers</h2>
          <p class="mb-6 text-lg text-gray-700">
            So they can speed up development process and learning for 0$ with our free plan.
          </p>
          <ul class="mb-6 space-y-2 list-none">
            <li class="text-gray-700">✔ All the features</li>
            <li class="text-gray-700">✔ 2 virtual processors</li>
            <li class="text-gray-700">✔ 500 MB of storage</li>
          </ul>
          <.link
            class="px-6 py-3 mx-auto text-white bg-blue-500 rounded-md transition-colors hover:bg-blue-600"
            phx-click="sign_up_free"
          >
            Sign Up for Free
          </.link>
        </div>
        <div class="flex flex-col justify-between p-8 rounded-lg">
          <h2 class="mb-4 text-3xl font-bold text-blue-500">For those who need more</h2>
          <p class="mb-6 text-lg text-gray-700">And don't want to be ripped off.</p>
          <ul class="mb-6 space-y-2 list-none">
            <li class="text-gray-700">✔ Everything in the free plan</li>
            <li class="text-gray-700">✔ 1 virtual processor for 0.50$</li>
            <li class="text-gray-700">✔ 1 GB of storage for 1$</li>
          </ul>
          <button
            class="px-6 py-3 mx-auto w-36 text-white bg-blue-500 rounded-md transition-colors hover:bg-blue-600"
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
