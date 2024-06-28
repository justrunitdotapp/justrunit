defmodule JustrunitWeb.Modules.Justboxes.ShowJustboxLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <%= if @error != false do %>
      <div class="flex flex-col items-center max-w-4xl mx-auto mt-12">
        <h1 class="text-2xl font-bold"><%= @error %></h1>
        <p>
          If you believe this is an error, please contact us at
          <a href="mailto:support@justrun.it">support@justrun.it</a>
        </p>
      </div>
    <% else %>
      <div class="flex flex-col items-center max-w-4xl mx-auto mt-12">
        <p><%= @description %></p>
      </div>
    <% end %>
    """
  end

  import Ecto.Query
  alias Justrunit.Repo

  def mount(_params, _session, socket) do
    socket = socket |> assign(error: false)
    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
  end

  def handle_params(params, _uri, socket) do
    user =
      from(u in JustrunitWeb.Modules.Accounts.User, where: u.handle == ^params["handle"])
      |> Repo.one()

    case user do
      nil ->
        socket = socket |> assign(error: "User not found")
        {:noreply, socket}

      user ->
        justbox =
          from(j in JustrunitWeb.Modules.Justboxes.Justbox,
            where: j.user_id == ^user.id and j.slug == ^params["justbox_slug"]
          )
          |> Repo.one()

        case justbox do
          nil ->
            socket = socket |> assign(error: "Justbox not found")
            {:noreply, socket}

          justbox ->
            socket = socket |> assign(description: justbox.description)
            {:noreply, socket}
        end
    end
  end
end
