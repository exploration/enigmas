defmodule EnigmaWeb.CoverLive do
  use EnigmaWeb, :live_view

  alias Enigma.Covers.{Cover, Example, Renderer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    cover_count = String.to_integer(params["cover_count"] || "15")
    shape_count = String.to_integer(params["shape_count"] || "5")
    size = String.to_integer(params["size"] || "300")
    variety = params["variety"] || "circle"
    socket = 
      assign(socket, 
        cover_count: cover_count, 
        shape_count: shape_count,
        size: size,
        variety: variety
      )
      |> create_covers()
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    cover_count = String.to_integer(params["cover_count"])
    shape_count = String.to_integer(params["shape_count"])
    size = String.to_integer(params["size"])
    variety = params["variety"]
    socket = push_patch(socket,
      to: Routes.cover_path(
        socket,
        :index,
        cover_count: cover_count,
        shape_count: shape_count,
        size: size,
        variety: variety
      )
    )
    {:noreply, socket}
  end

  defp create_covers(socket) do
    size_changed = socket.assigns[:previous_size] && socket.assigns.previous_size != socket.assigns.size 
    variety_changed = socket.assigns[:previous_variety] && socket.assigns.previous_variety != socket.assigns.variety 
    cond do
      size_changed ->
        covers = Enum.map socket.assigns.covers, fn cover ->
          %{cover | size: socket.assigns.size}
        end
        assign(socket, previous_size: socket.assigns.size, covers: covers)
      variety_changed ->
        covers = Enum.map socket.assigns.covers, fn cover ->
          %{cover | variety: socket.assigns.variety}
        end
        assign(socket, previous_variety: socket.assigns.variety, covers: covers)
      true ->
        covers = Enum.map 1..socket.assigns.cover_count, fn _i ->
          {:ok, cover} = Cover.create Example.cover(:all, 
            shape_count: socket.assigns.shape_count, 
            size: socket.assigns.size, 
            variety: socket.assigns.variety
          )
          cover
        end
        assign(socket, 
          previous_size: socket.assigns.size, 
          previous_variety: socket.assigns.variety, 
          covers: covers
        )
    end
  end
end
