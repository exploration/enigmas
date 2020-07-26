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
  def render(assigns) do
    ~L"""
    <section class="pa3">
      <%= f = form_for :adjustments, "#", phx_change: "refresh", phx_submit: "refresh" %>
        <div class="flex flex-wrap">
          <div class="w5 mr3">
            <%= label f, :size, class: xc("label") %>
            <%= range_input f, :size, value: @size, min: 25, max: 250, class: "w-100" %>
            <div class="flex justify-between">
              <div>25</div>
              <div>250</div>
            </div>
          </div>
          <div class="w5 mr3">
            <%= label f, :cover_count, class: xc("label") %>
            <%= range_input f, :cover_count, value: @cover_count, min: 1, max: 1000, class: "w-100" %>
            <div class="flex justify-between">
              <div>1</div>
              <div>1000</div>
            </div>
          </div>
          <div class="mt3">
            <button class="<%= xc "btn-s" %>">Refresh</button>
          </div>
        </div>
      </form>
      <div class="mt3">
        <%= for cover <- @covers do %>
          <%= raw Renderer.render_cover(cover) %>
        <% end %>
      </div>
    </section>
    """
  end

  @impl true
  def handle_event("refresh", %{"adjustments" => adjustments}, socket) do
    socket = 
      assign(socket, 
        cover_count: String.to_integer(adjustments["cover_count"]),
        size: String.to_integer(adjustments["size"])
      )
      |> create_covers()
    {:noreply, socket}
  end

  defp create_covers(socket) do
    covers = Enum.map 1..socket.assigns.cover_count, fn _i ->
      {:ok, cover} = Cover.create Example.cover(:all, size: socket.assigns.size)
      cover
    end
    assign(socket, covers: covers)
  end
end
