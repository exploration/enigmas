defmodule EnigmaWeb.CoverLive do
  use EnigmaWeb, :live_view

  alias Enigma.Covers.{Example, Shape}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, shape} = Shape.create Example.shape(:all)
    {:ok, assign(socket, shape: shape)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class="mt5 center measure-wide">
      <%= inspect @shape %>
      <div>
        <svg class="mt3" width="100" height="100" viewBox="0 0 100 100">
          <rect x="10" y="10" width="20" height="20" stroke="#333333" stroke-width="1px" /> 
        </svg>
      </div>
    </section>
    """
  end
end
