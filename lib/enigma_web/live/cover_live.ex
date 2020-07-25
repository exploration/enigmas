defmodule EnigmaWeb.CoverLive do
  use EnigmaWeb, :live_view

  alias Enigma.Covers.Shape

  @impl true
  def mount(_params, _session, socket) do
    {:ok, shape} = Shape.create Shape.example_params(:all)
    {:ok, assign(socket, shape: shape)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class="mt5 center measure-wide">
      <%= inspect @shape %>
    </section>
    """
  end
end
