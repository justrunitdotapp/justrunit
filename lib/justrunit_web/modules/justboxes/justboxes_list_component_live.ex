defmodule JustrunitWeb.Modules.Justboxes.JustboxesListComponentLive do
  use Phoenix.Component

  attr :justboxes, :list, required: true
  attr :user_handle, :string, required: true

  def justboxes_list_component(assigns) do
    ~H"""
    <div class="flex flex-col mt-4 w-full">
      <.justbox
        :for={{justbox, index} <- Enum.with_index(@justboxes)}
        name={justbox.name}
        user_handle={@user_handle}
        description={justbox.description}
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
  attr :description, :string, required: true
  attr :last_changed, :string, required: true

  def justbox(assigns) do
    assigns = assign(assigns, name_slug: Slug.slugify(assigns.name))

    border_class = if assigns.is_last, do: "", else: "border-b border-gray-300"
    assigns = assign(assigns, border_class: border_class)

    ~H"""
    <div class={"flex relative flex-col p-4 hover:bg-gray-50 group " <> @border_class}>
      <div class="flex justify-between items-center">
        <a
          href={"/#{@user_handle}/#{@name_slug}"}
          class="text-lg font-semibold text-gray-900 hover:underline"
        >
          <%= @name %>
        </a>
        <p class="text-sm text-gray-500">Last updated <%= @last_changed %></p>
      </div>
      <p class="mt-2 text-sm text-gray-600 break-words">
        <%= @description %>
      </p>
    </div>
    <!-- <button
            phx-click="delete_justbox"
            phx-value-slug={@name_slug}
            class="px-3 py-1 text-white bg-red-500 rounded-md hover:bg-red-600"
          >
            Yes
          </button> -->
    """
  end
end
