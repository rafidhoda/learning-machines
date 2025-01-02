defmodule LearningMachines.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LearningMachinesWeb.Telemetry,
      LearningMachines.Repo,
      {DNSCluster, query: Application.get_env(:learning_machines, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LearningMachines.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LearningMachines.Finch},
      # Start a worker by calling: LearningMachines.Worker.start_link(arg)
      # {LearningMachines.Worker, arg},
      # Start to serve requests, typically the last entry
      LearningMachinesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LearningMachines.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LearningMachinesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
