defmodule JustrunitWeb.Modules.Justboxes.ShowJustboxLive do
  use JustrunitWeb, :live_view
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
    <%= if @error != false do %>
      <div class="flex flex-col items-center mx-auto mt-12 max-w-4xl">
        <h1 class="text-2xl font-bold"><%= @error %></h1>
        <p>
          If you believe this is an error, please contact us at
          <a href="mailto:support@justrun.it">support@justrun.it</a>
        </p>
      </div>
    <% else %>
    <% end %>
    """
  end

  import Ecto.Query
  alias Justrunit.Repo
  alias JustrunitWeb.Modules

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
            result =
              ExAws.S3.list_objects("justrunit-dev", prefix: justbox.s3_key)
              |> ExAws.request()

            case result do
              {:error, _} ->
                socket = socket |> assign(error: "Failed to fetch justbox.")
                {:noreply, socket}

              {:ok, justboxes} ->
                s3_keys =
                  justboxes
                  |> Map.get(:body)
                  |> Map.get(:contents)
                  |> Enum.map(fn jb -> jb.key end)

                socket = socket |> assign(s3_keys: s3_keys)
                IO.inspect(socket)

                {:noreply, socket}
            end

            socket = socket |> assign(name: justbox.name)
            {:noreply, socket}
        end
    end
  end
end
