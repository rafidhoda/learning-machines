defmodule LearningMachines.CountersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LearningMachines.Counters` context.
  """

  @doc """
  Generate a counter.
  """
  def counter_fixture(attrs \\ %{}) do
    {:ok, counter} =
      attrs
      |> Enum.into(%{
        count: 42
      })
      |> LearningMachines.Counters.create_counter()

    counter
  end
end
