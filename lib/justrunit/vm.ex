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

  def validate_memory(""), do: {:error, "Memory size cannot be empty"}

  def validate_memory(memory_size) when is_binary(memory_size) do
    cond do
      !has_valid_postfix?(memory_size) ->
        {:error, "Invalid postfix, valid postfixes: k, K, m, M, g, G, t, T."}

      !positive_value?(memory_size) ->
        {:error, "Memory size must be positive"}

      true ->
        :ok
    end
  end

  defp has_valid_postfix?(binary) do
    String.ends_with?(binary, ["k", "K", "m", "M", "g", "G", "t", "T"])
  end

  defp positive_value?(binary) do
    {number, _postfix} = Integer.parse(binary)
    number > 0
  end
end
