defmodule AppWeb.TodoLive.Index do
  use AppWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(App.PubSub, "todos")
    end

    {:ok, assign(socket, :todos, [])}
  end

  def handle_info({:new_todo, content}, socket) do
    {:noreply, assign(socket, :todos, socket.assigns.todos ++ [content])}
  end
end
