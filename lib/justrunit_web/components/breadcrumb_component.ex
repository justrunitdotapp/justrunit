defmodule JustrunitWeb.BreadcrumbComponent do
  use Phoenix.Component
  import JustrunitWeb.CoreComponents

  attr :items, :list, required: true

  def breadcrumb(assigns) do
    assigns = assign(assigns, :size, length(assigns.items))

    ~H"""
    <nav class="flex" aria-label="breadcrumb">
      <ol class="inline-flex items-center space-x-1 md:space-x-3">
        <.breadcrumb_item
          :for={{item, index} <- Enum.with_index(@items)}
          type={index_to_item_type(index, @size)}
          navigate={item[:navigate]}
          text={item[:text]}
        />
      </ol>
    </nav>
    """
  end

  defp index_to_item_type(0, _size), do: "first"
  defp index_to_item_type(index, size) when size == index + 1, do: "last"
  defp index_to_item_type(_index, _size), do: "middle"

  attr :type, :string, default: "middle"
  attr :navigate, :string, default: "/"
  attr :text, :string, required: true

  defp breadcrumb_item(assigns) when assigns.type == "first" do
    ~H"""
    <li class="inline-flex items-center">
      <.link navigate={@navigate} class="inline-flex items-center text-sm font-medium">
        <.icon name="hero-home" class="h-4 w-4" />
      </.link>
    </li>
    """
  end

  defp breadcrumb_item(assigns) when assigns.type == "last" do
    ~H"""
    <li aria-current="page">
      <div class="flex items-center">
        <.icon name="hero-chevron-right" class="h-4 w-4" />
        <span class="ml-1 text-sm font-medium md:ml-2">
          <%= @text %>
        </span>
      </div>
    </li>
    """
  end

  defp breadcrumb_item(assigns) do
    ~H"""
    <li>
      <div class="flex items-center">
        <.icon name="hero-chevron-right" class="h-4 w-4" />
        <.link navigate={@navigate} class="ml-1 text-sm font-medium md:ml-2 ">
          <%= @text %>
        </.link>
      </div>
    </li>
    """
  end
end
