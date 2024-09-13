defmodule Justrunit.Vm do
  @moduledoc """
  Module for managing microVMs using Cloud Hypervisor.
  """

  def start(
        cpu_count,
        memory_size,
        disk_image,
        cloudinit_path \\ "/tmp/ubuntu-cloudinit.img",
        kernel_path \\ "/linux-cloud-hypervisor/arch/x86/boot/compressed/vmlinux.bin"
      ) do
    case validate_memory(memory_size) do
      :ok ->
        args = [
          "--kernel #{kernel_path}",
          "--disk path=#{disk_image} path=#{cloudinit_path}",
          "--cmdline \"console=hvc0 root=/dev/vda1 rw\"",
          "--cpus boot=#{cpu_count}",
          "--memory size=#{memory_size}",
          "--net \"tap=,mac=,ip=,mask=\""
        ]

        {output, exit_code} = System.cmd("cloud-hypervisor", args)

      {:error, error_message} ->
        IO.puts("Validation failed: #{error_message}")
    end
  end

  @spec validate_memory(String.t() | integer()) :: :ok | {:error, String.t()}
  def validate_memory(memory_size) when is_integer(memory_size) do
    if memory_size > 0 do
      :ok
    else
      {:error, "Memory size must be positive"}
    end
  end

  def validate_memory(memory_size) when is_binary(memory_size) do
    case memory_size do
      "" ->
        {:error, "Memory size cannot be empty"}

      <<_prefix::binary-size(1), rest::binary>> ->
        if prefix(rest) do
          parse_and_validate(rest)
        else
          {:error, "Invalid memory size format. Please use a valid unit (k, m, g, t)"}
        end

      _ ->
        {:error, "Invalid memory size format. Please use a valid unit (k, m, g, t)"}
    end
  end

  defp prefix(binary) do
    Enum.any?(["k", "K", "m", "M", "g", "G", "t", "T"], fn p -> String.starts_with?(binary, p) end)
  end

  defp parse_and_validate(binary) do
    case Integer.parse(binary) do
      {value, ""} when value > 0 ->
        :ok

      {_, ""} ->
        {:error, "Memory size must be positive"}

      _ ->
        {:error, "Invalid memory size format"}
    end
  end
end
