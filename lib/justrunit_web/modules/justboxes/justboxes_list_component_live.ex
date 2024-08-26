defmodule JustrunitWeb.Modules.Justboxes.JustboxesListComponentLive do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :justboxes, :list, required: true
  attr :user_handle, :string, required: true

  def justboxes_list_component(assigns) do
    ~H"""
    <div class="flex flex-col mt-4 w-full">
      <.justbox
        :for={{justbox, index} <- Enum.with_index(@justboxes)}
        name={justbox.name}
        user_handle={@user_handle}
        last_changed={since_last_edit(justbox.updated_at)}
        is_last={is_last?(index, Enum.count(@justboxes))}
      />
    </div>
    """
  end

  defp since_last_edit(naive_datetime) do
    now = DateTime.utc_now() |> DateTime.to_naive()
    diff = NaiveDateTime.diff(now, naive_datetime, :second)

    cond do
      diff < 60 ->
        "#{diff} second(s) ago"

      diff < 3600 ->
        minutes = div(diff, 60)
        "#{minutes} minute(s) ago"

      diff < 86400 ->
        hours = div(diff, 3600)
        "#{hours} hour(s) ago"

      diff < 2_592_000 ->
        days = div(diff, 86400)
        "#{days} day(s) ago"

      diff < 31_536_000 ->
        months = div(diff, 2_592_000)
        "#{months} month(s) ago"

      true ->
        years = div(diff, 31_536_000)
        "#{years} year(s) ago"
    end
  end

  defp is_last?(index, size) when size == index + 1, do: true
  defp is_last?(_, _), do: false

  attr :is_last, :boolean, default: false
  attr :name, :string, required: true
  attr :last_changed, :string, required: true

  def justbox(assigns) when assigns.is_last == false do
    assigns = assign(assigns, name_slug: Slug.slugify(assigns.name))

    ~H"""
    <div class="flex relative flex-row justify-between p-2 space-x-4 border-b border-gray-800 hover:bg-neutral-300 group">
      <a href={"/#{@user_handle}/#{@name_slug}"} class="font-medium hover:underline"><%= @name %></a>
      <p class="text-gray-600 group-hover:hidden">Last updated <%= @last_changed %></p>
      <button
        phx-click={JS.toggle(to: "#popover-content-#{@name_slug}")}
        phx-value-name={@name_slug}
        class="hidden font-medium text-red-500 group-hover:block hover:underline"
      >
        Remove
      </button>

      <div
        id={"popover-content-#{@name_slug}"}
        phx-click-away={JS.hide(to: "#popover-content-#{@name_slug}")}
        class="border border-zinc-300 p-4 rounded-md shadow-md bg-white absolute top-0 right-[-8px] transform translate-x-full z-1000 hidden"
      >
        <div class="absolute top-3 right-full w-0 h-0 border-t-8 border-r-8 border-b-8 border-t-transparent border-b-transparent border-r-zinc-300">
        </div>
        <p class="mb-2 font-medium text-center text-gray-800">Are you sure?</p>
        <div class="flex justify-center space-x-2">
          <button
            phx-click="delete_justbox"
            phx-value-slug={@name_slug}
            class="px-3 py-1 text-white bg-red-500 rounded-md hover:bg-red-600"
          >
            Yes
          </button>
          <button
            phx-click={JS.toggle(to: "#popover-content-#{@name_slug}")}
            class="px-3 py-1 text-gray-700 rounded-md border border-gray-300 hover:bg-zinc-200"
          >
            No
          </button>
        </div>
      </div>
    </div>
    """
  end

  def justbox(assigns) do
    assigns = assign(assigns, name_slug: Slug.slugify(assigns.name))

    ~H"""
    <div
      id={"popover-#{@name_slug}"}
      class="flex relative flex-row justify-between p-2 space-x-4 hover:bg-neutral-300 group"
    >
      <a href={"/#{@user_handle}/#{@name_slug}"} class="font-medium hover:underline">
        <%= @name %>
      </a>
      <p class="text-gray-600 group-hover:hidden">Last updated <%= @last_changed %></p>
      <button
        phx-click={JS.toggle(to: "#popover-content-#{@name_slug}")}
        phx-value-name={@name_slug}
        class="hidden font-medium text-red-500 group-hover:block hover:underline"
      >
        Remove
      </button>

      <div
        id={"popover-content-#{@name_slug}"}
        phx-click-away={JS.hide(to: "#popover-content-#{@name_slug}")}
        class="border border-zinc-300 p-4 rounded-md shadow-md bg-white absolute top-0 right-[-8px] transform translate-x-full z-1000 hidden"
      >
        <div class="absolute top-3 right-full w-0 h-0 border-t-8 border-r-8 border-b-8 border-t-transparent border-b-transparent border-r-zinc-300">
        </div>
        <p class="mb-2 font-medium text-center text-gray-800">Are you sure?</p>
        <div class="flex justify-center space-x-2">
          <button
            phx-click="delete_justbox"
            phx-value-slug={@name_slug}
            class="px-3 py-1 text-white bg-red-500 rounded-md hover:bg-red-600"
          >
            Yes
          </button>
          <button
            phx-click={JS.toggle(to: "#popover-content-#{@name_slug}")}
            class="px-3 py-1 text-gray-700 rounded-md border border-gray-300 hover:bg-zinc-200"
          >
            No
          </button>
        </div>
      </div>
    </div>
    """
  end
end
