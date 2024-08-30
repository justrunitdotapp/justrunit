defmodule JustrunitWeb.Modules.Rap.UnauthorizedHTML do
  use JustrunitWeb, :html

  def index(assigns) do
    ~H"""
      <div class="p-8 mx-auto mt-72 w-full max-w-md text-center bg-white rounded-lg">
        <svg
          class="mx-auto mb-6 w-20 h-20 text-blue-500"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
          >
          </path>
        </svg>
        <h1 class="mb-4 text-3xl font-bold text-gray-800">Unauthorized Access</h1>
        <p class="mb-6 text-gray-600">
          Sorry, you don't have permission to access this page. Please contact the support if you believe this is an error.
        </p>
      </div>
    """
  end
end
