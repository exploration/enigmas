defmodule EnigmaWeb.CoverLive do
  use EnigmaWeb, :live_view

  alias Enigma.Covers.{Cover, Example, Renderer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    cover_count = String.to_integer(params["cover_count"] || "5")
    size = String.to_integer(params["size"] || "50")
    variety = params["variety"] || "square"
    socket = 
      assign(socket, 
        cover_count: cover_count, 
        size: size,
        variety: variety
      )
      |> create_covers()
    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh", params, socket) do
    cover_count = String.to_integer(params["cover_count"])
    size = String.to_integer(params["size"])
    variety = params["variety"]
    socket = push_patch(socket,
      to: Routes.cover_path(
        socket,
        :index,
        cover_count: cover_count,
        size: size,
        variety: variety
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
          <div class="w5 mr4">
            <label for="cover_count" class="<%= xc("label") %>">
              Cover Count
            </label>
            <input type="range" name="cover_count" value="<%= @cover_count %>" min="1" max="1000" class="w-100">
            <div class="flex justify-between">
              <div>1</div>
              <div>1000</div>
            </div>
          </div>
          <div class="w5 mr4">
            <label for="size" class="<%= xc("label") %>">
              Size
            </label>
            <input type="range" name="size" value="<%= @size %>" min="10" max="750" class="w-100">
            <div class="flex justify-between">
              <div>10</div>
              <div>750</div>
            </div>
          </div>
          <div class="mr5">
            <div class="<%= xc("label") %>">
              Variety
            </div>
            <div class="flex">
              <label class="flex mr3">
                <input type="radio" name="variety" value="circle" class="mr1 w-100" <%= if @variety == "circle", do: "checked=\"checked\"" %>>
                Circle
              </label>
              <label class="flex">
                <input type="radio" name="variety" value="square" class="mr1 w-100" <%= if @variety == "square", do: "checked=\"checked\"" %>>
                Square
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
          <%= link raw(Renderer.render_cover(cover)), to: Routes.cover_download_path(@socket, :show, Cover.encode64(cover)), target: "enigma", class: "no-underline" %>
        <% end %>
      </div>
    </section>
    """
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
