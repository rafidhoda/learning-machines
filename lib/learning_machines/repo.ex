defmodule LearningMachines.Repo do
  use Ecto.Repo,
    otp_app: :learning_machines,
    adapter: Ecto.Adapters.Postgres
end
