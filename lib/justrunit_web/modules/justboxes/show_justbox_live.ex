defmodule JustrunitWeb.Modules.Justboxes.ShowJustboxLive do
  use JustrunitWeb, :live_view

  def render(assigns) do
    ~H"""
    <%= if @error do %>
      <div class="flex flex-col items-center mx-auto mt-12 max-w-4xl">
        <h1 class="text-2xl font-bold"><%= @error %></h1>
        <p>
          If you believe this is an error, please contact us at
          <a href="mailto:support@justrun.it">support@justrun.it</a>
        </p>
      </div>
    <% else %>
       <.svelte
        name="Jeditor"
        props={%{s3_keys: @s3_keys, justbox_name: @justbox_name, value: @file}}
        socket={@socket}
      />
    <% end %>
    """
  end

  import Ecto.Query
  alias Justrunit.Repo
  alias Justrunit.S3

  def mount(_params, _session, socket) do
    socket = socket |> assign(error: false) |> assign(file: "")
    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
  end

  def handle_params(params, _uri, socket) do
    {justbox_name, s3_keys} = load_justbox(params["handle"], params["justbox_slug"], socket)
    user = get_user_by_handle(params["handle"])

    case user do
      {:ok, user} ->
        socket =
          socket
          |> assign(
            justbox_name: justbox_name,
            s3_keys: s3_keys,
            current_justbox_owner_id: user.id
          )

        {:noreply, socket}

      {:error, reason} ->
        socket = socket |> put_flash(:error, "Error while loading justbox")
        {:noreply, socket}
    end
  end

  def handle_event(
        "refresh_explorer",
        %{"handle" => handle, "justbox_slug" => justbox_slug},
        socket
      ) do
    {justbox_name, s3_keys} = load_justbox(handle, justbox_slug, socket)
    IO.inspect(socket.assigns)

    socket = socket |> assign(justbox_name: justbox_name, s3_keys: s3_keys)
    {:noreply, socket}
  end

  def handle_event("new_file", %{"handle" => handle, "file_s3_key" => file_s3_key}, socket) do
    {:ok, justbox_owner} = get_user_by_handle(handle)

    S3.put_object("#{justbox_owner.id}/#{socket.assigns.justbox_name}/#{file_s3_key}", "some_content123")
    |> case do
      {:ok, :created} ->
        updated_keys = [file_s3_key | socket.assigns.s3_keys]
        socket = socket |> assign(s3_keys: updated_keys)
        {:noreply, socket}

      {:error, reason} ->
        socket = socket |> put_flash(:error, "Failed to create a file")
        {:noreply, socket}
    end
  end

  def handle_event("update_file", %{"s3_key" => s3_key, "content" => content}, socket) do
    S3.put_object(
      "#{socket.assigns.current_justbox_owner_id}/#{socket.assigns.justbox_name}/#{s3_key}",
      content
    )
    |> case do
      {:ok, _} ->
        {:noreply, socket}

      {:error, _error} ->
        socket =
          socket
          |> put_flash(:error, "Failed to save")

        {:noreply, socket}
    end
  end

  def handle_event("new_folder", %{"handle" => handle}, socket) do
    S3.put_object(
      "justrunit",
      "#{socket.assigns.current_justbox_owner_id}/#{socket.assigns.justbox_name}/folder3/",
      ""
    )
    |> case do
      {:ok, _} ->
        {:noreply, socket}

      {:error, _reason} ->
        socket = socket |> put_flash(:error, "Failed to create a folder")
        {:noreply, socket}
    end
  end

  def handle_event("fetch_file", %{"s3_key" => s3_key}, socket) do
    res = S3.read_object("#{socket.assigns.current_justbox_owner_id}/#{socket.assigns.justbox_name}/#{s3_key}")

    case res do
      {:ok, content} ->
        socket = socket |> assign(file: content)
        {:noreply, socket}

      {:error, _reason} ->
        socket = socket |> put_flash(:error, "Failed to fetch a file")
        {:noreply, socket}
    end
  end

  def load_justbox(user_handle, justbox_slug, socket) do
    with {:ok, user} <- get_user_by_handle(user_handle),
         {:ok, justbox} <- get_justbox_by_slug(user.id, justbox_slug),
         {:ok, {:ok, justboxes}} <- list_s3_objects(justbox.s3_key) do
      s3_keys =
        justboxes
        |> Map.get(:body)
        |> Map.get(:contents)
        |> Enum.map(fn jb -> jb.key end)
        |> Enum.map(&(String.split(&1, "/") |> Enum.drop(2) |> Enum.join("/")))

      {justbox.name, s3_keys}
    else
      {:error, :user_is_nil} ->
        socket = socket |> assign(error: "User not found")
        {"Failed to fetch", []}

      {:error, :justbox_is_nil} ->
        socket = socket |> assign(error: "Justbox not found")
        {"Failed to fetch", []}

      {:error, :failed_to_fetch_from_s3} ->
        socket = 
          socket 
          |> assign(error: "Failed to fetch justbox.")

        {"Failed to fetch", []}
    end
  end

  defp get_user_by_handle(handle) do
    user =
      from(u in JustrunitWeb.Modules.Accounts.User, where: u.handle == ^handle)
      |> Repo.one()

    case user do
      nil ->
        {:error, :user_is_nil}
      user ->
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_justbox_by_slug(user_id, slug) do
    justbox =
      from(j in JustrunitWeb.Modules.Justboxes.Justbox,
        where: j.user_id == ^user_id and j.slug == ^slug
      )
      |> Repo.one()

    if justbox do
      {:ok, justbox}
    else
      {:error, :justbox_is_nil}
    end
  end

  defp list_s3_objects(s3_key) do
    res = S3.list_objects(s3_key)

    case res do
    {:ok, justboxes} ->
      {:ok, justboxes}
    {:error, reason} ->
      {:error, :failed_to_fetch_from_s3}
    end
  end
end
