defmodule JustrunitWeb.Modules.Justboxes.NewJustboxLive do
  use Phoenix.LiveView
  import JustrunitWeb.CoreComponents, only: [button: 1, input: 1]
  import JustrunitWeb.BreadcrumbComponent, only: [breadcrumb: 1]

  def render(assigns) do
    ~H"""
    <div class="flex flex-col max-w-4xl mx-auto mt-12 space-y-8">
      <.breadcrumb items={[%{label: "JustBoxes", navigate: "/justboxes"}, %{text: "New JustBox"}]} />
      <.form for={@form} phx-submit="new" class="w-full space-y-4">
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
        <div class="container" phx-drop-target={@uploads.project.ref}>
          <.live_file_input upload={@uploads.project} />
        </div>
        <.button type="submit" class="mt-4">Create</.button>
      </.form>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Justboxes.Justbox

  def mount(_params, _session, socket) do
    form = to_form(Justbox.changeset(%Justbox{}, %{}))
    socket = socket |> assign(already_exists: false) |> assign(uploaded: []) |> allow_upload(:project, accept: :any)
    {:ok, assign(socket, form: form), layout: {JustrunitWeb.Layouts, :app}}
  end

  alias Justrunit.Repo
  import Ecto.Query

  def handle_event("new", %{"justbox" => params}, socket) do
    params = params
    |> Map.update!("name", &String.replace(&1, ~r/ {2,}/, " ") |> String.trim())
    |> Map.put("s3_key", "#{socket.assigns.current_user.id}/#{params["slug"]}")
    |> Map.put("user_id", socket.assigns.current_user.id)
    |> Map.put("slug", Justrunit.slugify(params["name"]))

    if Repo.exists?(from j in Justbox, where: j.slug == ^params["slug"]) do
      changeset = Justbox.changeset(%Justbox{}, %{
        "name" => params["name"],
        "description" => params["description"],
        "slug" => params["slug"],
        "s3_key" => params["s3_key"],
        "user_id" => socket.assigns.current_user.id
      })

      socket = socket
      |> assign(form: to_form(changeset))
      |> assign(already_exists: true)

      {:noreply, socket}
    else
      case Justbox.changeset(%Justbox{}, params) |> Repo.insert() do
        {:ok, _} ->
          result = ExAws.S3.put_object(bucket: "justrunit", key: params["s3_key"], body: "test") |> ExAws.request()
          handle_s3_result(result, socket, params)

        {:error, changes} ->
          {:noreply, assign(socket, form: to_form(changes))}
      end
    end
  end

  defp handle_s3_result({:ok, _}, socket, params) do
    user = Repo.get(JustrunitWeb.Modules.Accounts.User, socket.assigns.current_user.id)
    {:noreply, push_navigate(socket, to: "/#{user.handle}/#{params["slug"]}")}
  end

  defp handle_s3_result({:error, _}, socket, params) do
    socket = socket |> put_flash(:error, "Error occurred while uploading")
    {:noreply, assign(socket, form: to_form(Justbox.changeset(%Justbox{}, params)))}
  end
end
