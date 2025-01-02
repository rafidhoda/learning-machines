defmodule LearningMachinesWeb.CounterLive.Show do
  use LearningMachinesWeb, :live_view

  alias LearningMachines.Counters

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(LearningMachines.PubSub, "counters:updates")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:counter, Counters.get_counter!(id))}
  end

  @impl true
  def handle_event("increment", _, socket) do
    counter = socket.assigns.counter
    updated_counter = Counters.increment_counter(counter)

    Phoenix.PubSub.broadcast(LearningMachines.PubSub, "counters:updates", {:updated_counter, updated_counter})

    {:noreply, assign(socket, :counter, updated_counter)}
  end

  @impl true
  def handle_event("decrement", _, socket) do
    counter = socket.assigns.counter
    updated_counter = Counters.decrement_counter(counter)

    Phoenix.PubSub.broadcast(LearningMachines.PubSub, "counters:updates", {:updated_counter, updated_counter})

    {:noreply, assign(socket, :counter, updated_counter)}
  end

  @impl true
  def handle_info({:updated_counter, updated_counter}, socket) do
    if updated_counter.id == socket.assigns.counter.id do
      {:noreply, assign(socket, :counter, updated_counter)}
    else
      {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Counter"
  defp page_title(:edit), do: "Edit Counter"
end
