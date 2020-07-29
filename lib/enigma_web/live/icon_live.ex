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
    height = get_dimension params, "height"
    shape_count = String.to_integer(params["shape_count"] || "5")
    width = get_dimension params, "width"
    variety = params["variety"] || "circle"
    socket = 
      assign(socket, 
        icon_count: icon_count, 
        height: height,
        shape_count: shape_count,
        variety: variety,
        width: width
      )
      |> create_icons()
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    icon_count = String.to_integer(params["icon_count"])
    shape_count = String.to_integer(params["shape_count"])
    height = get_dimension params, "height"
    variety = params["variety"]
    width = get_dimension params, "width"
    socket = push_patch(socket,
      to: Routes.icon_path(
        socket,
        :index,
        icon_count: icon_count,
        height: height,
        shape_count: shape_count,
        variety: variety,
        width: width
      )
    )
    {:noreply, socket}
  end

  defp create_icons(socket) do
    height_changed = socket.assigns[:previous_height] && socket.assigns.previous_height != socket.assigns.height 
    width_changed = socket.assigns[:previous_width] && socket.assigns.previous_width != socket.assigns.width 
    variety_changed = socket.assigns[:previous_variety] && socket.assigns.previous_variety != socket.assigns.variety 
    cond do
      height_changed ->
        icons = Enum.map socket.assigns.icons, fn icon ->
          %{icon | height: socket.assigns.height}
        end
        assign(socket, previous_height: socket.assigns.height, icons: icons)
      variety_changed ->
        icons = Enum.map socket.assigns.icons, fn icon ->
          %{icon | variety: socket.assigns.variety}
        end
        assign(socket, previous_variety: socket.assigns.variety, icons: icons)
      width_changed ->
        icons = Enum.map socket.assigns.icons, fn icon ->
          %{icon | width: socket.assigns.width}
        end
        assign(socket, previous_height: socket.assigns.height, icons: icons)
      true ->
        icons = Enum.map 1..socket.assigns.icon_count, fn _i ->
          {:ok, icon} = Icon.create Example.icon(:all, 
            shape_count: socket.assigns.shape_count, 
            height: socket.assigns.height, 
            variety: socket.assigns.variety,
            width: socket.assigns.width
          )
          icon
        end
        assign(socket, 
          previous_height: socket.assigns.height, 
          previous_variety: socket.assigns.variety, 
          previous_width: socket.assigns.width, 
          icons: icons
        )
    end
  end

  def get_dimension(params, key) do
    case params[key] do
      "" -> 300
      nil -> 300
      key -> String.to_integer key
    end
  end
end
