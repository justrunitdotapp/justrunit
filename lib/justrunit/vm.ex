defmodule Justrunit.Vm do
  @moduledoc """
  Module for managing microVMs using Cloud Hypervisor.
  """

  def start(cpu_count, memory_size, disk_image, cloudinit_path) do
    kernel_path = System.get_env("KERNEL_PATH")

    case validate_memory(memory_size) do
      :ok ->
        cmd = [
          "--kernel #{kernel_path}",
          "--disk path=#{disk_image} path=#{initrd_path}",
          "--cmdline \"console=hvc0 root=/dev/vda1 rw\"",
          "--cpus boot=#{cpu_count}",
          "--memory size=#{memory_size}",
          "--net \"tap=,mac=,ip=,mask=\""
        ]

      {:error, error_message} ->
        IO.puts("Validation failed: #{error_message}")
    end

    {output, exit_code} = System.cmd("cloud-hypervisor", args)
  end

  @spec validate_memory(String.t()) :: :ok | {:error, String.t()}
  def validate_memory(memory_size) do
    case memory_size do
      "" ->
        {:error, "Memory size cannot be empty"}

      <<_prefix::binary-size(1), rest / binary>> when prefix(rest) ->
        parse_and_validate(rest)

      _ ->
        {:error, "Invalid memory size format. Please use a valid unit (k, m, g, t)"}
    end
  end

  defp prefix(binary) do
    ["k", "K", "m", "M", "g", "G", "t", "T"] |> Enum.any?(fn p -> binary =~ ^p end)
  end

  defp parse_and_validate(binary) do
    case Integer.parse(binary) do
      {value, _} when value > 0 ->
        :ok

      _ ->
        {:error, "Memory size must be positive"}
    end
  end
end
