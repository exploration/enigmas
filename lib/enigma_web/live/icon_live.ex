defmodule EnigmaWeb.IconLive do
  use EnigmaWeb, :live_view

  alias Enigma.Icons.{Icon, Example, Renderer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    fill_color = params["fill_color"] || "#FFFFFF"
    height = get_dimension params, "height"
    icon_count = String.to_integer(params["icon_count"] || "15")
    shape_count = String.to_integer(params["shape_count"] || "5")
    stroke_color = params["stroke_color"] || "#233E52"
    stroke_width = String.to_integer(params["stroke_width"] || "2")
    width = get_dimension params, "width"
    variety = params["variety"] || "circle"
    socket = 
      assign(socket, 
        fill_color: fill_color, 
        icon_count: icon_count, 
        height: height,
        shape_count: shape_count,
        stroke_color: stroke_color,
        stroke_width: stroke_width,
        variety: variety,
        width: width
      )
      |> assign_previous_values()
      |> create_icons()
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    fill_color = params["fill_color"]
    height = get_dimension params, "height"
    icon_count = String.to_integer(params["icon_count"])
    shape_count = String.to_integer(params["shape_count"])
    stroke_color = params["stroke_color"]
    stroke_width = String.to_integer(params["stroke_width"])
    variety = params["variety"]
    width = get_dimension params, "width"
    socket = push_patch(socket,
      to: Routes.icon_path(
        socket,
        :index,
        fill_color: fill_color,
        icon_count: icon_count,
        height: height,
        shape_count: shape_count,
        stroke_color: stroke_color,
        stroke_width: stroke_width,
        variety: variety,
        width: width
      )
    )
    {:noreply, socket}
  end

  def handle_event("reset", _params, socket) do
    socket = 
      assign(socket, 
        previous_fill_color: nil,
        previous_height: nil,
        previous_stroke_color: nil,
        previous_stroke_width: nil,
        previous_variety: nil,
        previous_width: nil
      )
      |> push_patch(to: Routes.icon_path(socket, :index))
    {:noreply, socket}
  end

  defp create_icons(socket) do
    fill_color_changed = socket.assigns[:previous_fill_color] && socket.assigns.previous_fill_color != socket.assigns.fill_color 
    height_changed = socket.assigns[:previous_height] && socket.assigns.previous_height != socket.assigns.height 
    stroke_color_changed = socket.assigns[:previous_stroke_color] && socket.assigns.previous_stroke_color != socket.assigns.stroke_color 
    stroke_width_changed = socket.assigns[:previous_stroke_width] && socket.assigns.previous_stroke_width != socket.assigns.stroke_width 
    variety_changed = socket.assigns[:previous_variety] && socket.assigns.previous_variety != socket.assigns.variety 
    width_changed = socket.assigns[:previous_width] && socket.assigns.previous_width != socket.assigns.width 

    cond do
      fill_color_changed ->
        icons = Enum.map socket.assigns.icons, fn icon -> %{icon | fill_color: socket.assigns.fill_color} end
        assign(socket, previous_fill_color: socket.assigns.fill_color, icons: icons)
      height_changed ->
        icons = Enum.map socket.assigns.icons, fn icon -> %{icon | height: socket.assigns.height} end
        assign(socket, previous_height: socket.assigns.height, icons: icons)
      stroke_color_changed ->
        icons = Enum.map socket.assigns.icons, fn icon -> %{icon | stroke_color: socket.assigns.stroke_color} end
        assign(socket, previous_stroke_color: socket.assigns.stroke_color, icons: icons)
      stroke_width_changed ->
        icons = Enum.map socket.assigns.icons, fn icon -> %{icon | stroke_width: socket.assigns.stroke_width} end
        assign(socket, previous_stroke_width: socket.assigns.stroke_width, icons: icons)
      variety_changed ->
        icons = Enum.map socket.assigns.icons, fn icon -> %{icon | variety: socket.assigns.variety} end
        assign(socket, previous_variety: socket.assigns.variety, icons: icons)
      width_changed ->
        icons = Enum.map socket.assigns.icons, fn icon -> %{icon | width: socket.assigns.width} end
        assign(socket, previous_width: socket.assigns.width, icons: icons)
      true ->
        icons = Enum.map 1..socket.assigns.icon_count, fn _i ->
          {:ok, icon} = Icon.create Example.icon(:all, 
            fill_color: socket.assigns.fill_color, 
            height: socket.assigns.height, 
            shape_count: socket.assigns.shape_count, 
            stroke_color: socket.assigns.stroke_color, 
            stroke_width: socket.assigns.stroke_width, 
            variety: socket.assigns.variety,
            width: socket.assigns.width
          )
          icon
        end
        socket
        |> assign_previous_values()
        |> assign(icons: icons)
    end
  end

  defp get_dimension(params, key) do
    case params[key] do
      "" -> 300
      nil -> 300
      key -> String.to_integer key
    end
  end

  defp assign_previous_values(socket) do
    assign(socket, 
      previous_fill_color: socket.assigns.fill_color, 
      previous_height: socket.assigns.height, 
      previous_stroke_color: socket.assigns.stroke_color, 
      previous_stroke_width: socket.assigns.stroke_width, 
      previous_variety: socket.assigns.variety, 
      previous_width: socket.assigns.width
    )
  end
end
