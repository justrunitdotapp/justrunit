defmodule Justrunit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JustrunitWeb.Telemetry,
      Justrunit.Repo,
      {DNSCluster, query: Application.get_env(:justrunit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Justrunit.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Justrunit.Finch},
      # Start a worker by calling: Justrunit.Worker.start_link(arg)
      # {Justrunit.Worker, arg},
      # Start to serve requests, typically the last entry
      JustrunitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Justrunit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JustrunitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
