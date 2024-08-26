defmodule JustrunitWeb.Modules.Justboxes.JustboxesListLive do
  use JustrunitWeb, :live_view

  import JustrunitWeb.Modules.Justboxes.JustboxesListComponentLive,
    only: [justboxes_list_component: 1]

  import JustrunitWeb.PaginationComponent, only: [pagination: 1]

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center mx-auto mt-12 max-w-4xl">
      <div class="flex justify-between items-baseline w-full">
        <h1 class="text-2xl font-bold">Your JustBoxes</h1>
        <.link
          class="p-2 font-semibold text-white rounded-lg border-2 hover:bg-neutral-700 bg-neutral-900"
          patch="/new-justbox"
        >
          New JustBox
        </.link>
      </div>
      <div class="flex flex-col my-8 w-full">
        <.justboxes_list_component justboxes={@justboxes} user_handle={@user_handle} />
      </div>
      <%= if @pages_count > 1 do %>
        <.pagination
          page_number={@page_number}
          pages_count={@pages_count}
          previous_page?={@previous_page?}
          next_page?={@next_page?}
        />
      <% end %>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Justboxes.Justbox
  alias Justrunit.S3
  alias Justrunit.Repo

  def mount(_params, _session, socket) do
    socket = socket |> assign(show_modal: false)
    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
  end

  def handle_event("delete_justbox", %{"slug" => slug}, socket) do
    current_user_id = socket.assigns.current_user.id
    justbox = Justrunit.Repo.get_by(Justbox, user_id: current_user_id, slug: slug)

    if is_nil(justbox) do
      {:noreply,
       put_flash(socket, :error, "Failed to delete justbox, it might have been already removed.")}
    else
      case Repo.delete(justbox) do
        {:ok, _} ->
          handle_s3_deletion(justbox.s3_key, socket)

        _ ->
          {:noreply,
           put_flash(
             socket,
             :error,
             "Failed to delete justbox, it might have been already removed."
           )}
      end
    end
  end

  defp handle_s3_deletion(s3_key, socket) do
    case S3.list_objects_by_prefix(s3_key) do
      {:ok, %{"ListBucketResult" => %{"Contents" => []}}} ->
        {:noreply,
         socket |> put_flash(:info, "Justbox already removed.")}

      {:ok, %{"ListBucketResult" => %{"Contents" => contents}}} ->
        Enum.each(contents, fn %{"Key" => key} -> S3.delete_object(key) end)
        {:noreply, socket |> put_flash(:info, "Justbox removed") |> push_patch(to: ~p"/justboxes")}

      _ ->
        {:noreply,
         put_flash(
           socket,
           :error,
           "Failed to delete justbox, it might have been already removed."
         )}
    end
  end

  def handle_params(%{"page" => page}, _uri, socket) do
    p = %{order_by: ["updated_at"], page: page, page_size: 15, order_directions: [:desc]}
    page = String.to_integer(page)

    {:ok, {justboxes, meta}} =
      Flop.validate_and_run(
        Justbox,
        Map.put(p, :filters, [%{field: :user_id, op: :==, value: socket.assigns.current_user.id}]),
        repo: Justrunit.Repo
      )

    d = div(meta.total_count, p.page_size)
    q = rem(meta.total_count, p.page_size)
    pages_count = if q == 0, do: d, else: d + 1

    socket =
      socket
      |> assign(justboxes: justboxes)
      |> assign(page_number: page)
      |> assign(pages_count: pages_count)
      |> assign(next_page?: meta.has_next_page?)
      |> assign(previous_page?: meta.has_previous_page?)
      |> assign(user_handle: socket.assigns.current_user.handle)

    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    handle_params(%{"page" => "1"}, _uri, socket)
  end
end
