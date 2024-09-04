defmodule JustrunitWeb.PaginationComponent do
  use JustrunitWeb, :live_view

  attr :page_number, :integer, required: true
  attr :pages_count, :integer, required: true
  attr :previous_page?, :boolean, required: true
  attr :next_page?, :boolean, required: true

  def pagination(assigns) do
    ~H"""
    <div class="flex items-center space-x-2">
      <%= if @previous_page? do %>
        <.link
          patch={~p"/justboxes?page=#{@page_number - 1}"}
          class="px-4 py-2 h-10 font-bold text-white bg-blue-500 rounded-md"
        >
          <.icon name="hero-arrow-left" class="w-6 h-6" />
        </.link>
      <% else %>
        <a
          href="#"
          class="px-4 py-2 h-10 font-bold text-white bg-blue-400 rounded-md cursor-not-allowed"
        >
          <.icon name="hero-arrow-left" class="w-6 h-6" />
        </a>
      <% end %>

      <%= for page <- 1..@pages_count do %>
        <%= if page == @page_number do %>
          <a
            href="#"
            class="px-4 py-2 h-10 font-bold text-white bg-blue-500 rounded-md border-2 border-blue-500"
          >
            <%= page %>
          </a>
        <% else %>
          <.link
            patch={~p"/justboxes?page=#{page}"}
            class="px-4 py-2 h-10 font-bold text-blue-500 rounded-md border-2 border-blue-500 hover:bg-neutral-300"
          >
            <%= page %>
          </.link>
        <% end %>
      <% end %>

      <%= if @next_page? do %>
        <.link
          patch={~p"/justboxes?page=#{@page_number + 1}"}
          class="px-4 py-2 h-10 font-bold text-white bg-blue-500 rounded-md"
        >
          <.icon name="hero-arrow-right" class="w-6 h-6" />
        </.link>
      <% else %>
        <a
          href="#"
          class="px-4 py-2 h-10 font-bold text-white bg-blue-400 rounded-md cursor-not-allowed"
        >
          <.icon name="hero-arrow-right" class="w-6 h-6" />
        </a>
      <% end %>
    </div>
    """
  end

  def handle_event("next", _params, socket) do
    socket = socket |> assign(page_number: socket.assigns.page_number + 1)
    {:noreply, socket}
  end

  def handle_event("previous", _params, socket) do
    socket = socket |> assign(page_number: socket.assigns.page_number - 1)
    {:noreply, socket}
  end
end
