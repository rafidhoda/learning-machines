defmodule LearningMachinesWeb.CounterLive.FormComponent do
  use LearningMachinesWeb, :live_component

  alias LearningMachines.Counters

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage counter records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="counter-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:count]} type="number" label="Count" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Counter</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{counter: counter} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Counters.change_counter(counter))
     end)}
  end

  @impl true
  def handle_event("validate", %{"counter" => counter_params}, socket) do
    changeset = Counters.change_counter(socket.assigns.counter, counter_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"counter" => counter_params}, socket) do
    save_counter(socket, socket.assigns.action, counter_params)
  end

  defp save_counter(socket, :edit, counter_params) do
    case Counters.update_counter(socket.assigns.counter, counter_params) do
      {:ok, counter} ->
        notify_parent({:saved, counter})

        {:noreply,
         socket
         |> put_flash(:info, "Counter updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_counter(socket, :new, counter_params) do
    case Counters.create_counter(counter_params) do
      {:ok, counter} ->
        notify_parent({:saved, counter})

        {:noreply,
         socket
         |> put_flash(:info, "Counter created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
