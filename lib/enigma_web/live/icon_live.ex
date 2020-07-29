defmodule EnigmaWeb.IconLive do
  use EnigmaWeb, :live_view

  alias Enigma.Icons.{Icon, Example, Renderer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    icon_count = String.to_integer(params["icon_count"] || "15")
    shape_count = String.to_integer(params["shape_count"] || "5")
    size = String.to_integer(params["size"] || "300")
    variety = params["variety"] || "circle"
    socket = 
      assign(socket, 
        icon_count: icon_count, 
        shape_count: shape_count,
        size: size,
        variety: variety
      )
      |> create_icons()
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    icon_count = String.to_integer(params["icon_count"])
    shape_count = String.to_integer(params["shape_count"])
    size = String.to_integer(params["size"])
    variety = params["variety"]
    socket = push_patch(socket,
      to: Routes.icon_path(
        socket,
        :index,
        icon_count: icon_count,
        shape_count: shape_count,
        size: size,
        variety: variety
      )
    )
    {:noreply, socket}
  end

  defp create_icons(socket) do
    size_changed = socket.assigns[:previous_size] && socket.assigns.previous_size != socket.assigns.size 
    variety_changed = socket.assigns[:previous_variety] && socket.assigns.previous_variety != socket.assigns.variety 
    cond do
      size_changed ->
        icons = Enum.map socket.assigns.icons, fn icon ->
          %{icon | size: socket.assigns.size}
        end
        assign(socket, previous_size: socket.assigns.size, icons: icons)
      variety_changed ->
        icons = Enum.map socket.assigns.icons, fn icon ->
          %{icon | variety: socket.assigns.variety}
        end
        assign(socket, previous_variety: socket.assigns.variety, icons: icons)
      true ->
        icons = Enum.map 1..socket.assigns.icon_count, fn _i ->
          {:ok, icon} = Icon.create Example.icon(:all, 
            shape_count: socket.assigns.shape_count, 
            size: socket.assigns.size, 
            variety: socket.assigns.variety
          )
          icon
        end
        assign(socket, 
          previous_size: socket.assigns.size, 
          previous_variety: socket.assigns.variety, 
          icons: icons
        )
    end
  end
end
