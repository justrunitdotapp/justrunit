defmodule Justrunit.Vm do
  @moduledoc """
  Module for managing microVMs using Cloud Hypervisor.
  """

  def new(disk_path) do
    kernel_path = System.get_env("KERNEL_PATH")

    command = [
      "cloud-hypervisor",
      "--api-socket",
      "/tmp/cloud-hypervisor.sock",
      "--kernel",
      kernel_path,
      "--disk",
      "path=#{disk_path},size=1G,read_only=false",
      "--memory",
      "size=512M",
      "--cpus",
      "boot=1",
      "--net",
      "tap=tap0,mac=AA:BB:CC:DD:EE:FF",
      "--boot-from-uefi"
    ]

    case System.cmd("sh", ["-c", Enum.join(command, " ")]) do
      {output, 0} ->
        {:ok, output}

      {error_message, _exit_code} ->
        {:error, error_message}
    end
  end
end
