defmodule JustrunitWeb.Modules.Accounts.Profile.ProfileLive do
  use JustrunitWeb, :live_view
  alias JustrunitWeb.Modules.Justboxes.JustboxesListLive
  

  def render(assigns) do
    ~H"""
    <div class="p-6 mx-auto mt-10 max-w-4xl bg-white border-b border-gray-300">
        <div class="flex items-center rounded-full bg-hero-wiggle">
            <img class="rounded-full border-2 border-gray-300 size-24" src="https://via.placeholder.com/150" alt="Profile Picture">
            <div class="ml-6">
                <h1 class="text-2xl font-bold text-gray-800"><%= @name %></h1>
                <p class="text-gray-600"><%= @handle %></p>
            </div>
        </div>

        <div class="mt-6">
            <h2 class="text-lg font-semibold text-gray-800">About Me</h2>
            <p class="mt-2 text-gray-600">
                <%= @bio %>
            </p>
        </div>
    </div>
    """
  end

  alias Justrunit.Repo
  import Ecto.Query

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    user =
      from(u in JustrunitWeb.Modules.Accounts.User, where: u.handle == ^params["handle"])
      |> Repo.one()

    socket = assign(socket, name: user.name, handle: user.handle, bio: user.bio)
    {:noreply, socket}
  end
end
