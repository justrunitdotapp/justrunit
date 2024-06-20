defmodule JustrunitWeb.PaginationComponent do
  use JustrunitWeb, :live_view

  attr :page_number, :integer, required: true
  attr :pages_count, :integer, required: true

  def pagination(assigns) do
    ~H"""
    <div class="flex items-center space-x-2">
      <%= if @page_number > 1 do %>
        <.link
          patch={~p"/justboxes/#{@page_number - 1}"}
          class="bg-blue-500 text-white px-4 py-2 rounded-md font-bold h-10"
        >
          <.icon name="hero-arrow-left" class="w-6 h-6" />
        </.link>
      <% else %>
        <a
          href="#"
          class="bg-blue-400 cursor-not-allowed text-white px-4 py-2 rounded-md font-bold h-10"
        >
          <.icon name="hero-arrow-left" class="w-6 h-6" />
        </a>
      <% end %>

       <%= for page <- 1..@pages_count do %>
        <.link
          patch={~p"/justboxes/#{page}"}
          class="border-2 border-blue-500 text-blue-500 px-4 py-2 rounded-md font-bold h-10"
        >
          <%= page %>
        </.link>
      <% end %>


      <%= if @page_number < @pages_count do %>
        <.link
          patch={~p"/justboxes/#{@page_number + 1}"}
          class="bg-blue-500 text-white px-4 py-2 rounded-md font-bold h-10"
        >
          <.icon name="hero-arrow-right" class="w-6 h-6" />
        </.link>
      <% else %>
        <a
          href="#"
          class="bg-blue-400 cursor-not-allowed text-white px-4 py-2 rounded-md font-bold h-10"
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
