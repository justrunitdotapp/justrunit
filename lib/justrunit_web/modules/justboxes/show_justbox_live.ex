defmodule JustrunitWeb.Modules.Justboxes.ShowJustboxLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center max-w-4xl mx-auto mt-12">
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {JustrunitWeb.Layouts, :app}}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
