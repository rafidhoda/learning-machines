defmodule LearningMachinesWeb.CounterLive.Index do
  use LearningMachinesWeb, :live_view

  alias LearningMachines.Counters
  alias LearningMachines.Counters.Counter

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :counters, Counters.list_counters())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Counter")
    |> assign(:counter, Counters.get_counter!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Counter")
    |> assign(:counter, %Counter{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Counters")
    |> assign(:counter, nil)
  end

  @impl true
  def handle_info({LearningMachinesWeb.CounterLive.FormComponent, {:saved, counter}}, socket) do
    {:noreply, stream_insert(socket, :counters, counter)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    counter = Counters.get_counter!(id)
    {:ok, _} = Counters.delete_counter(counter)

    {:noreply, stream_delete(socket, :counters, counter)}
  end
end
