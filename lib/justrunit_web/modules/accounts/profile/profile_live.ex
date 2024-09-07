defmodule JustrunitWeb.Modules.Accounts.Profile.ProfileLive do
  use JustrunitWeb, :live_view

  import JustrunitWeb.Modules.Justboxes.JustboxesListComponentLive,
    only: [justboxes_list_component: 1]

  import JustrunitWeb.PaginationComponent, only: [pagination: 1]

  def render(assigns) do
    ~H"""
    <div class="p-6 mx-auto mt-10 max-w-4xl bg-white">
      <div class="flex items-center rounded-full bg-hero-wiggle">
        <img
          class="rounded-full border-2 border-gray-300 size-24"
          src="https://via.placeholder.com/150"
          alt="Profile Picture"
        />
        <div class="ml-6">
          <h1 class="text-2xl font-bold text-gray-800"><%= @name %></h1>
          <p class="text-gray-600"><%= @handle %></p>
        </div>
      </div>

      <div class="pb-4 mt-6 border-b border-gray-300">
        <h2 class="text-lg font-semibold text-gray-800">About Me</h2>
        <p class="mt-2 text-gray-600">
          <%= @bio %>
        </p>
      </div>
      <div class="flex flex-col items-center">
        <div class="flex flex-col my-8 w-full">
          <.justboxes_list_component justboxes={@justboxes} user_handle={@handle} />
        </div>
        <%= if @pages_count > 1 do %>
          <.pagination
            current_route={@handle}
            page_number={@page_number}
            pages_count={@pages_count}
            previous_page?={@previous_page?}
            next_page?={@next_page?}
          />
        <% end %>
      </div>
    </div>
    """
  end

  alias JustrunitWeb.Modules.Justboxes.Justbox
  alias Justrunit.Repo
  import Ecto.Query

  def mount(_params, session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    p = %{
      order_by: ["updated_at"],
      page: params["page"] || "1",
      page_size: 15,
      order_directions: [:desc]
    }

    page =
      if params["page"] == nil do
        1
      else
        page = params["page"] |> String.to_integer()
      end

    user =
      from(u in JustrunitWeb.Modules.Accounts.User, where: u.handle == ^params["handle"])
      |> Repo.one()

    {:ok, {justboxes, meta}} =
      Flop.validate_and_run(
        Justbox,
        Map.put(p, :filters, [%{field: :user_id, op: :==, value: user.id}]),
        repo: Justrunit.Repo
      )

    d = div(meta.total_count, p.page_size)
    q = rem(meta.total_count, p.page_size)
    pages_count = if q == 0, do: d, else: d + 1

    socket =
      assign(socket,
        name: user.name,
        handle: user.handle,
        bio: user.bio,
        justboxes: justboxes,
        page_number: page,
        pages_count: pages_count,
        next_page?: meta.has_next_page?,
        previous_page?: meta.has_previous_page?
      )

    {:noreply, socket}
  end
end
