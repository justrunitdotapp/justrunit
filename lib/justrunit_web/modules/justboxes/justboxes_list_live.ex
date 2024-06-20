defmodule JustrunitWeb.Modules.Justboxes.JustboxesListLive do
  use Phoenix.LiveView

  import JustrunitWeb.Modules.Justboxes.JustboxesListComponentLive,
    only: [justboxes_list_component: 1]

  import JustrunitWeb.PaginationComponent, only: [pagination: 1]

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center max-w-4xl mx-auto mt-12">
      <div class="flex items-baseline justify-between w-full">
        <h1 class="text-2xl font-bold">Your JustBoxes</h1>
        <.link
          class="text-white hover:bg-neutral-700 border-2 bg-neutral-900 p-2 rounded-lg font-semibold"
          patch="/justboxes/new"
        >
          New JustBox
        </.link>
      </div>
      <div class="flex flex-col w-full my-8">
        <.justboxes_list_component justboxes={@justboxes} />
      </div>
      <%= if @pages_count > 1 do %>
        <.pagination page_number={@page_number} pages_count={@pages_count} />
      <% end %>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Justboxes.Justbox

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
  end

  def handle_params(%{"page" => page}, _uri, socket) do
    p = %{order_by: ["updated_at"], page: page, page_size: 15}
    page = String.to_integer(page)
    {:ok, {justboxes, meta}} =
      Flop.validate_and_run(Justbox, p, repo: Justrunit.Repo)

    d = div(meta.total_count, p.page_size)
    q = rem(meta.total_count, p.page_size)
    pages_count = if q == 0, do: d, else: d + 1

    socket =
      socket
      |> assign(justboxes: justboxes)
      |> assign(page_number: page)
      |> assign(pages_count: pages_count)

    {:noreply, socket}
  end
end
