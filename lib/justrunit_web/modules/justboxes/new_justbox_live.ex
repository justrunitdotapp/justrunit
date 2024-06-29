defmodule JustrunitWeb.Modules.Justboxes.NewJustboxLive do
  use Phoenix.LiveView
  import JustrunitWeb.CoreComponents, only: [button: 1, input: 1, icon: 1]
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
    <div class="flex flex-col max-w-4xl mx-auto mt-12">
      <.breadcrumb items={[%{label: "JustBoxes", navigate: "/justboxes"}, %{text: "New JustBox"}]} />
      <.form for={@form} phx-submit="new" phx-change="validate" class="w-full space-y-4">
        <h1 class="text-2xl font-bold">New JustBox</h1>
        <.input field={@form[:name]} label="Name" type="text" class="w-full" />
        <%= if @already_exists do %>
          <div>
            <p class="text-red-600">Such Justbox already exists!</p>
            <p class="text-sm text-gray-600">
              Remember that spaces and dashes are treated the same, "My Justbox" and "My-Justbox" are considered identical.
            </p>
          </div>
        <% end %>
        <.input field={@form[:description]} label="Description" type="textarea" class="w-full" />
        <%= if @uploads.project.errors do %>
          <div>
            <p class="text-red-600">
              <%= for {_, %{message: message}} <- @uploads.project.errors do %>
                <%= message %>
              <% end %>
            </p>
          </div>
        <% end %>

        <div class="w-full container flex flex-col items-center justify-center size-96 bg-gradient-to-r from-blue-400 to-blue-600 rounded-lg p-6 shadow-lg">
          <%= if @uploads.project.entries == [] do %>
            <div class="flex flex-col text-white items-center justify-center space-y-2 my-auto">
              <h1 class="text-3xl font-bold">Upload files here</h1>
              <.icon name="hero-arrow-down-tray" class="size-36" />
            </div>
          <% else %>
            <ul class="overflow-y-auto space-y-2 w-full rounded-lg">
              <%= for entry <- @uploads.project.entries do %>
                <li class="flex text-white border border-white rounded-xl justify-between items-center">
                  <p class="pl-2 font-medium"><%= entry.client_name %></p>
                  <a
                    href="#"
                    phx-click="remove_upload"
                    phx-value-ref={entry.ref}
                    class="font-bold bg-white text-blue-600 p-2 rounded-r-lg hover:bg-zinc-300"
                  >
                    Remove<.icon name="hero-trash-solid ml-2" class="size-6 bg-blue-600" />
                  </a>
                </li>
              <% end %>
            </ul>
          <% end %>
          <div class="w-full mt-auto pt-4">
            <.live_file_input class="hidden" upload={@uploads.project} />
            <input
              id="project"
              type="file"
              webkitdirectory={true}
              phx-hook="Upload"
              class="w-full p-4 text-white rounded-xl bg-gradient-to-r from-blue-500 to-blue-700 transparent"
            />
          </div>
        </div>

        <.button type="submit" phx-disable-with="Setting up your Justbox..." class="mt-4">
          Create
        </.button>
      </.form>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Justboxes.Justbox

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    form = to_form(Justbox.changeset(%Justbox{}, %{}))

    socket =
      socket
      |> assign(form: form)
      |> assign(already_exists: false)
      |> assign(uploaded_files: [])
      |> allow_upload(:project, accept: :any, max_entries: 500)

    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
  end

  alias Justrunit.Repo
  import Ecto.Query

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    IO.inspect(socket.assigns.uploads.project.entries)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("remove_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :project, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("new", %{"justbox" => params}, socket) do
    params =
      params
      |> Map.update!("name", &(String.replace(&1, ~r/ {2,}/, " ") |> String.trim()))
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("slug", Slug.slugify(params["name"]))
      |> Map.put("s3_key", "#{socket.assigns.current_user.id}/#{Slug.slugify(params["name"])}")

    with false <- Repo.exists?(from j in Justbox, where: j.slug == ^params["slug"]),
         results <-
           consume_uploaded_entries(socket, :project, fn %{path: path}, entry ->
             ExAws.S3.put_object(
               "justrunit-dev",
               "#{params["s3_key"]}/#{entry.client_name}",
               File.read!(path)
             )
             |> ExAws.request()
           end),
         {:ok, _} <-
           Enum.find_value(results, fn
             %{status_code: 200} -> {:ok, :success}
             {:error, reason} -> {:error, reason}
           end),
         {:ok, _} <- Justbox.changeset(%Justbox{}, params) |> Repo.insert() do
      handle_s3_result(:ok, socket, params)
    else
      true ->
        changeset =
          Justbox.changeset(%Justbox{}, %{
            "name" => params["name"],
            "description" => params["description"],
            "slug" => params["slug"],
            "s3_key" => params["s3_key"],
            "user_id" => socket.assigns.current_user.id
          })

        socket =
          socket
          |> assign(form: to_form(changeset))
          |> assign(already_exists: true)

        {:noreply, socket}

      {:error, reason} ->
        socket = socket |> put_flash(:error, "Error occurred while uploading")
        {:noreply, assign(socket, form: to_form(Justbox.changeset(%Justbox{}, params)))}

      {:error, changes} ->
        {:noreply, assign(socket, form: to_form(changes))}
    end
  end

  defp handle_s3_result(:ok, socket, params) do
    user = Repo.get(JustrunitWeb.Modules.Accounts.User, socket.assigns.current_user.id)
    {:noreply, push_navigate(socket, to: "/#{user.handle}/#{params["slug"]}")}
  end

  defp handle_s3_result({:error, _}, socket, params) do
    socket = socket |> put_flash(:error, "Error occurred while uploading")
    {:noreply, assign(socket, form: to_form(Justbox.changeset(%Justbox{}, params)))}
  end
end
