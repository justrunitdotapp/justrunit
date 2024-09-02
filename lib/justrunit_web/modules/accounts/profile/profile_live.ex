defmodule JustrunitWeb.Modules.Accounts.Profile.ProfileLive do
  use JustrunitWeb, :live_view
  alias JustrunitWeb.Modules.Justboxes.JustboxesListLive
  

  def render(assigns) do
    ~H"""
    <section class="py-32 bg-hero-hideout"></section>
    <section class="flex flex-col items-center">
      <p class="text-3xl font-medium"><%= @name %></p>
      <p class="text-gray-600"><%= @handle %></p>
    </section>
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

    socket = assign(socket, name: user.name, handle: user.handle)
    {:noreply, socket}
  end
end
