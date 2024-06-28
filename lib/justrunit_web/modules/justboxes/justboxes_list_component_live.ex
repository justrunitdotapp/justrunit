defmodule JustrunitWeb.Modules.Justboxes.JustboxesListComponentLive do
  use Phoenix.Component

  attr :justboxes, :list, required: true
  attr :user_handle, :string, required: true

  def justboxes_list_component(assigns) do
    ~H"""
    <div class="flex flex-col w-full mt-4">
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
    <div class="p-2 hover:bg-neutral-300 border-b border-gray-800 flex flex-row justify-between space-x-4">
      <a href={"/#{@user_handle}/#{@name_slug}"} class="font-medium hover:underline"><%= @name %></a>
      <p class="text-gray-600">Last updated <%= @last_changed %></p>
    </div>
    """
  end

  def justbox(assigns) do
    assigns = assign(assigns, name_slug: Slug.slugify(assigns.name))

    ~H"""
    <div class="p-2 hover:bg-neutral-300 flex flex-row justify-between space-x-4">
      <a href={"/#{@user_handle}/#{@name_slug}"} class="font-medium hover:underline"><%= @name %></a>
      <p class="text-gray-600">Last updated <%= @last_changed %></p>
    </div>
    """
  end
end
