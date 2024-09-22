defmodule Justrunit.CalculateRam
    @moduledoc """
        Calculates max. amount of RAM cloud hypervisor container can use and assigns it to a environmental variable every 60 seconds.
    """

    @second 1_000
    @max_usage 0.8
    @execution_interval 60 * @second

    use GenServer

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)

  @impl true
  def init(:ok), do: schedule_update() && {:ok, %{}}

  @impl true
  def handle_info(:update, state) do
    update_max_ram()
    schedule_update()
    {:noreply, state}
  end

  defp schedule_update, do: Process.send_after(self(), :update, @execution_interval)

  defp update_max_ram do
    max_ram = round(:erlang.memory(:total) * 0.8)
    System.put_env("MAX_RAM", Integer.to_string(max_ram))
    IO.puts("Updated MAX_RAM to #{max_ram} bytes")
  end
end