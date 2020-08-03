defmodule EnigmaWeb.IconLive do
  use EnigmaWeb, :live_view

  alias Enigma.Icons.{Icon, Example, Renderer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    fill_color = params["fill_color"] || "#ffffff"
    height = get_dimension params, "height"
    icon_count = String.to_integer(params["icon_count"] || "15")
    page_color = params["page_color"] || "#ffffff"
    shape_count = String.to_integer(params["shape_count"] || "5")
    spacing = params["spacing"] || "5"
    stroke_color = params["stroke_color"] || "#233e52"
    stroke_width = String.to_integer(params["stroke_width"] || "2")
    width = get_dimension params, "width"
    variety = params["variety"] || "circle"
    socket = 
      create_icons(socket, %{
        page_color: page_color,
        spacing: spacing,

        icon_count: icon_count,
        shape_count: shape_count,

        fill_color: fill_color, 
        height: height,
        stroke_color: stroke_color,
        stroke_width: stroke_width,
        variety: variety,
        width: width
      })
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    fill_color = params["fill_color"]
    height = get_dimension params, "height"
    icon_count = String.to_integer(params["icon_count"])
    page_color = params["page_color"]
    shape_count = String.to_integer(params["shape_count"])
    spacing = String.to_integer(params["spacing"])
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
        page_color: page_color,
        spacing: spacing,
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
    socket = push_redirect(socket,  to: Routes.icon_path(socket, :index))
    {:noreply, socket}
  end

  defp find_changed_params(socket, params) do
    Enum.find(params, false, fn {key, value} ->
      Map.get(socket.assigns, key, value) != value
    end) 
  end

  defp create_icons(socket, updates) do
    change_list = Map.to_list(updates)
    icons = 
      updated_page?(socket, updates) ||
      updated_params?(socket, updates) ||
      Enum.map((1..updates.icon_count), fn _i ->
        {:ok, icon} = Icon.create Example.icon(:all, 
          change_list ++ [shape_count: updates.shape_count]
        )
        icon
      end)
    assign(socket, [icons: icons] ++ change_list)
  end

  defp get_dimension(params, key) do
    case params[key] do
      "" -> 300
      nil -> 300
      key -> String.to_integer key
    end
  end

  defp updated_page?(socket, updates) do
    page_params = %{
      page_color: updates.page_color,
      spacing: updates.spacing
    }
    if find_changed_params(socket, page_params) do
      socket.assigns.icons
    else
      false
    end
  end

  defp updated_params?(socket, updates) do
    update_params = %{
      fill_color: updates.fill_color, 
      height: updates.height,
      stroke_color: updates.stroke_color,
      stroke_width: updates.stroke_width,
      variety: updates.variety,
      width: updates.width
    }
    if pair = find_changed_params(socket, update_params) do
      {key, value} = pair
      Enum.map socket.assigns.icons, fn icon -> 
        %{icon | key => value} 
      end
    else
      false
    end
  end
end
