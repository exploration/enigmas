defmodule EnigmaWeb.CoverLive do
  use EnigmaWeb, :live_view

  alias Enigma.Covers.{Cover, Example, Renderer}

  @impl true
  def mount(_params, _session, socket) do
    socket = 
      assign(socket, cover_count: 5, size: 100)
      |> create_covers()
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    IO.inspect params
    cover_count = String.to_integer(params["cover_count"] || "5")
    size = String.to_integer(params["size"] || "50")
    style = params["style"] || "rectangle"
    socket = 
      assign(socket, 
        cover_count: cover_count, 
        size: size,
        style: style
      )
      |> create_covers()
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    cover_count = String.to_integer(params["cover_count"])
    size = String.to_integer(params["size"])
    style = params["style"]
    socket = push_patch(socket,
      to: Routes.cover_path(
        socket,
        :index,
        cover_count: cover_count,
        size: size,
        style: style
      )
    )
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class="pa3">
      <form phx-change="refresh" phx-submit="refresh">
        <div class="flex flex-wrap">
          <div class="w5 mr3">
            <label for="cover_count" class="<%= xc("label") %>">
              Cover Count
            </label>
            <input type="range" name="cover_count" value="<%= @cover_count %>" min="1" max="1000" class="w-100">
            <div class="flex justify-between">
              <div>1</div>
              <div>1000</div>
            </div>
          </div>
          <div class="w5 mr3">
            <label for="size" class="<%= xc("label") %>">
              Size
            </label>
            <input type="range" name="size" value="<%= @size %>" min="10" max="500" class="w-100">
            <div class="flex justify-between">
              <div>10</div>
              <div>500</div>
            </div>
          </div>
          <div class="mr3">
            <div class="flex">
              <label class="flex mr3 <%= xc "label" %>">
                <input type="radio" name="style" value="circle" class="mr1 w-100" <%= if @style == "circle", do: "checked=\"checked\"" %>>
                Circle
              </label>
              <label class="flex <%= xc "label" %>">
                <input type="radio" name="style" value="rectangle" class="mr1 w-100" <%= if @style == "rectangle", do: "checked=\"checked\"" %>>
                Rectangle
              </label>
            </div>
          </div>
          <div class="mt3">
            <button class="<%= xc "btn-s" %>">Refresh</button>
          </div>
        </div>
      </form>
      <div class="mt3">
        <%= for cover <- @covers do %>
          <%= if @style == "rectangle" do %>
            <%= raw Renderer.render_cover_rectangle(cover) %>
          <% else %>
            <%= raw Renderer.render_cover_circle(cover) %>
          <% end %>
        <% end %>
      </div>
    </section>
    """
  end


  defp create_covers(socket) do
    covers = Enum.map 1..socket.assigns.cover_count, fn _i ->
      {:ok, cover} = Cover.create Example.cover(:all, size: socket.assigns.size)
      cover
    end
    assign(socket, covers: covers)
  end
end
